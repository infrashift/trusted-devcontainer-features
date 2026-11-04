---
id: "01a1837f-e09c-765d-bc25-876b9b9d8840"
title: "Pinned CI tools"
type: "component"
tags:
  - "supply-chain"
  - "tools-lock"
  - "pin"
created: "2026-10-28T12:12:38-05:00"
timestamp: "2026-10-28T12:20:27-05:00"
description: "tools.lock pins cosign, syft, grype, opa, gitleaks and the devcontainer CLI; install-tools.sh verifies opa and gitleaks checksums."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:27-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/tools.lock"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/install-tools.sh"
    title: "scripts/install-tools.sh"
---

# Pinned CI tools

`tools.lock` pins the version of each CI tool. Nothing in CI installs a tool from a mutable reference. Some of these tools run in a job that holds a signing key.

## What `tools.lock` pins

`COSIGN_VERSION`, `SYFT_VERSION`, `GRYPE_VERSION`, `OPA_VERSION`, `GITLEAKS_VERSION` and `DEVCONTAINER_CLI_VERSION`. Read the current values in `tools.lock`.

The file stays byte-compatible with `tools.lock` in `trusted-devcontainer-templates`. Thus one version bump applies to both repositories.

## cosign v2

`tools.lock` pins cosign v2 on purpose. cosign v3 writes attestations as OCI referrers by default. The sibling repositories read the v2 layout. Change all repositories of the organization together. `release.yaml` sets `cosign-release` in `sigstore/cosign-installer` to the same version. Keep the two in step.

## `scripts/install-tools.sh`

Usage: `scripts/install-tools.sh <tool>...`, with `BIN` as the target directory (default `/usr/local/bin`).

| Tool | Verification |
|---|---|
| `opa` | Pinned SHA256 for each version and architecture in the script |
| `gitleaks` | Pinned SHA256 for each version and architecture in the script |
| `syft`, `grype` | The Anchore installer at the pinned tag verifies the release checksum |
| `devcontainer-cli` | `npm install -g @devcontainers/cli@<version>` |

A version without a pinned checksum fails by name. After the install, the script runs `$BIN/<tool>`, not the bare name, so it reports the binary that it installed.

## Enforcement

The [PDP](/supply-chain/policy-decision-point-pdp--01a1837fdf26.md) denies with `TOOL_NOT_PINNED` when a value does not start with `X.Y.Z`, and with `TOOLS_LOCK_MISSING` when it cannot read the file. `CODEOWNERS` marks `tools.lock` and `install-tools.sh` as trust decisions.

## Related

* [Policy decision point (PDP)](/supply-chain/policy-decision-point-pdp--01a1837fdf26.md)
* [Workflow lint](/supply-chain/workflow-lint--01a1837fe026.md)
* [CODEOWNERS](/supply-chain/codeowners--01a1837fe0ed.md)
* [Run the static checks and the repo gate locally](/operations/run-the-static-checks-and-the-repo-gate-locally--01a1837fe1ba.md)
* [Supply chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
