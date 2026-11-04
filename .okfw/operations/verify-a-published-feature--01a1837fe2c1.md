---
id: "01a1837f-e2c1-7d70-94a5-3afd5c3451ba"
title: "Verify a published feature"
type: "runbook"
tags:
  - "runbook"
  - "signing"
  - "verify"
created: "2026-10-28T12:12:38-05:00"
timestamp: "2026-10-28T12:20:27-05:00"
description: "Verify the signature of a published feature with cosign and the committed release.pub key."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:27-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/.github/pdp/public-keys/release.pub"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/sign-features.sh"
    title: "scripts/sign-features.sh"
---

# Verify a published feature

Use this procedure to verify that a feature in `ghcr.io/infrashift/trusted-devcontainer-features` came from the release of this repository. The Release-Actor signs each feature two times: with the release key, and keyless with a Rekor entry.

## Prerequisites

* `cosign`, and a copy of `.github/pdp/public-keys/release.pub`.
* `crane` and `jq` for steps 3 and 4.

## Procedure

1. Verify the keyed signature:

   ```bash
   cosign verify --key .github/pdp/public-keys/release.pub \
     ghcr.io/infrashift/trusted-devcontainer-features/<id>:<version>
   ```

2. Verify the keyless signature:

   ```bash
   cosign verify \
     --certificate-identity 'https://github.com/infrashift/trusted-devcontainer-features/.github/workflows/release.yaml@refs/heads/main' \
     --certificate-oidc-issuer https://token.actions.githubusercontent.com \
     ghcr.io/infrashift/trusted-devcontainer-features/<id>:<version>
   ```

3. Get the digest with `crane digest ghcr.io/infrashift/trusted-devcontainer-features/<id>:<version>`.
4. Read the dependency of the feature:

   ```bash
   crane manifest ghcr.io/infrashift/trusted-devcontainer-features/<id>@<digest> \
     | jq -r '.annotations["dev.containers.metadata"] | fromjson | .dependsOn'
   ```

5. Make sure that the key is `ghcr.io/infrashift/trusted-devcontainer-features/bootstrap@sha256:<64 hex>`.

Steps 1 and 2 passed for `jq:1.5.3` on 2026-10-28.

## Related

* [Signing actors and keys](/supply-chain/signing-actors-and-keys--01a1837fdf43.md)
* [Feature dependency model](/architecture/feature-dependency-model--01a1837fddea.md)
* [Release and promote the features](/operations/release-and-promote-the-features--01a1837fe1e1.md)
* [Operations overview](/operations/operations-overview--01a1837af719.md)
