# okfw Feature

Installs [okfw](https://github.com/infrashift/okf-wiki), the OKF Wiki CLI and MCP server.

## Install Location

- Binary: `~/.local/bin/okfw`
- MCP server: the same binary, `okfw mcp` (stdio)

## Verification

The role installs nothing until both gates pass:

1. **Checksum.** `get_url` verifies the tarball against the SHA256 pinned in
   `vars/main.yml` for the version and architecture, or against
   `target_checksum`.
2. **Signature.** `library/okfw_verify_blob.py` verifies the tarball's
   `.sigstore.json` bundle against the okf-wiki release key, which is pinned in
   `vars/main.yml` and never downloaded. It is the check
   `cosign verify-blob --key cosign.pub --insecure-ignore-tlog=true` performs,
   done with the `cryptography` package in the bootstrap venv (a dependency of
   ansible-core), because the image has neither cosign nor the openssl CLI.

okf-wiki signs releases offline and records no Rekor entry, so the
transparency log is not checked: the pinned key and the pinned checksum are the
trust root. The module rejects keyless (certificate) bundles rather than
half-verifying them.

## Other versions

Pass `target_checksum` for any version that is not pinned. Take it from that
release's `SHA256SUMS` after verifying the file's signature:

```bash
cosign verify-blob --key cosign.pub --insecure-ignore-tlog=true \
  --bundle SHA256SUMS.sigstore.json SHA256SUMS
```

Check that `cosign.pub` has SHA-256
`f912afb812fabb332536ced8efac95664de9e4519ead41613ddd944161484289`. A release
signed by a different key fails the signature gate; supporting it means
changing `_okfw_cosign_public_key` and bumping this feature's version.

## Registering the MCP server

The feature writes no MCP client configuration. Register the server per
project, for example in `.mcp.json`:

```json
{
  "mcpServers": {
    "okfw": { "type": "stdio", "command": "okfw", "args": ["mcp"] }
  }
}
```

## Versions

See available versions at https://github.com/infrashift/okf-wiki/releases
