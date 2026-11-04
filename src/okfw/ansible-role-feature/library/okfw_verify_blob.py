#!/usr/bin/python
# okfw-feature/ansible-role-feature/library/okfw_verify_blob.py
# Licensed under the MIT License.
#
# Verifies a key-signed sigstore bundle for one file -- the check
#
#   cosign verify-blob --key cosign.pub --insecure-ignore-tlog=true \
#       --bundle <file>.sigstore.json <file>
#
# performs, without cosign. The base image has no cosign and no openssl CLI,
# but the bootstrap venv that runs every module already has `cryptography`: it
# is a hard dependency of ansible-core. A role-local module adds no download
# and no package, and runs in the userland lane.
#
# Scope, deliberately narrow:
#   * key-based bundles only (verificationMaterial.publicKey). A keyless bundle
#     (Fulcio certificate + Rekor entry) is REJECTED, not half-verified: this
#     module cannot check a certificate chain or an inclusion proof.
#   * messageSignature only. A DSSE envelope (attestation) is rejected.
#   * the transparency log is not consulted. okf-wiki signs offline and records
#     no Rekor entry, so the pinned key is the whole trust root.
from __future__ import annotations

DOCUMENTATION = r"""
module: okfw_verify_blob
short_description: Verify a key-signed sigstore bundle for a file
description:
  - Checks that I(bundle) is a sigstore C(messageSignature) bundle made with the
    key I(public_key), that its message digest is the SHA256 of I(path), and
    that the ECDSA signature over that digest is valid.
  - Reads only. It always reports C(changed=false).
options:
  path:
    description: The file the bundle signs.
    type: path
    required: true
  bundle:
    description: The sigstore bundle (C(.sigstore.json)) for I(path).
    type: path
    required: true
  public_key:
    description: The trusted public key, PEM. ECDSA P-256 only.
    type: str
    required: true
"""

import base64
import hashlib
import json
import re

from ansible.module_utils.basic import AnsibleModule

try:
    from cryptography.exceptions import InvalidSignature
    from cryptography.hazmat.primitives import hashes, serialization
    from cryptography.hazmat.primitives.asymmetric import ec
    from cryptography.hazmat.primitives.asymmetric.utils import Prehashed

    HAS_CRYPTOGRAPHY = True
except ImportError:  # pragma: no cover - ansible-core always ships it
    HAS_CRYPTOGRAPHY = False

# v0.1/v0.2 use a version parameter, v0.3+ a versioned media type.
_MEDIA_TYPE = re.compile(
    r"^application/vnd\.dev\.sigstore\.bundle"
    r"(\.v0\.[0-9]+\+json|\+json;version=0\.[0-9]+)$"
)


class VerifyError(Exception):
    pass


def _b64(value, what):
    try:
        return base64.b64decode(value, validate=True)
    except (TypeError, ValueError) as exc:
        raise VerifyError(f"bundle {what} is not valid base64: {exc}") from exc


def sha256_file(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.digest()


def load_key(pem):
    try:
        key = serialization.load_pem_public_key(pem.encode())
    except ValueError as exc:
        raise VerifyError(f"public_key is not a PEM public key: {exc}") from exc
    if not isinstance(key, ec.EllipticCurvePublicKey) or key.curve.name != "secp256r1":
        raise VerifyError("public_key must be an ECDSA P-256 key")
    return key


def key_hint(key):
    """cosign's publicKey.hint: base64(sha256(DER SubjectPublicKeyInfo))."""
    der = key.public_bytes(
        serialization.Encoding.DER, serialization.PublicFormat.SubjectPublicKeyInfo
    )
    return base64.b64encode(hashlib.sha256(der).digest()).decode()


def verify(path, bundle_path, public_key_pem):
    key = load_key(public_key_pem)

    try:
        with open(bundle_path, "rb") as f:
            bundle = json.load(f)
    except (OSError, ValueError) as exc:
        raise VerifyError(f"cannot read bundle {bundle_path}: {exc}") from exc
    if not isinstance(bundle, dict):
        raise VerifyError("bundle is not a JSON object")

    media_type = bundle.get("mediaType", "")
    if not _MEDIA_TYPE.match(media_type):
        raise VerifyError(f"bundle mediaType {media_type!r} is not a sigstore bundle")

    material = bundle.get("verificationMaterial") or {}
    if "publicKey" not in material:
        # A certificate means keyless signing, which this module cannot verify.
        raise VerifyError(
            "bundle is not key-signed (no verificationMaterial.publicKey); "
            "keyless bundles are not supported"
        )

    expected_hint = key_hint(key)
    hint = (material.get("publicKey") or {}).get("hint")
    if hint and hint != expected_hint:
        raise VerifyError(
            f"bundle was signed by a different key (hint {hint}, pinned key {expected_hint})"
        )

    msg = bundle.get("messageSignature")
    if not isinstance(msg, dict):
        raise VerifyError("bundle has no messageSignature (a DSSE envelope is not supported)")

    md = msg.get("messageDigest") or {}
    if md.get("algorithm") != "SHA2_256":
        raise VerifyError(f"bundle digest algorithm {md.get('algorithm')!r} is not SHA2_256")

    actual = sha256_file(path)
    claimed = _b64(md.get("digest", ""), "messageDigest.digest")
    if claimed != actual:
        raise VerifyError(
            f"bundle signs a different file: bundle digest {claimed.hex()}, "
            f"file digest {actual.hex()}"
        )

    signature = _b64(msg.get("signature", ""), "messageSignature.signature")
    try:
        key.verify(signature, actual, ec.ECDSA(Prehashed(hashes.SHA256())))
    except InvalidSignature as exc:
        raise VerifyError("signature is NOT valid for the pinned key") from exc

    return {"sha256": actual.hex(), "key_hint": expected_hint, "media_type": media_type}


def main():
    module = AnsibleModule(
        argument_spec={
            "path": {"type": "path", "required": True},
            "bundle": {"type": "path", "required": True},
            "public_key": {"type": "str", "required": True, "no_log": False},
        },
        supports_check_mode=True,
    )
    if not HAS_CRYPTOGRAPHY:
        module.fail_json(msg="okfw_verify_blob needs the cryptography package")

    p = module.params
    try:
        result = verify(p["path"], p["bundle"], p["public_key"])
    except (OSError, VerifyError) as exc:
        module.fail_json(msg=f"Signature verification FAILED for {p['path']}: {exc}")

    module.exit_json(
        changed=False,
        msg=f"Signature verified for {p['path']} (sha256 {result['sha256']})",
        **result,
    )


if __name__ == "__main__":
    main()
