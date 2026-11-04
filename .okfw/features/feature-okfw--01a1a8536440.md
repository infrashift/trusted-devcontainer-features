---
id: "01a1a853-6440-7d8c-93b8-0f67cfcfdeb1"
title: "Feature: okfw"
type: "feature"
tags:
  - "feature"
  - "okfw"
  - "signing"
created: "2026-11-04T14:49:59-06:00"
timestamp: "2026-11-04T14:49:59-06:00"
description: "The okfw feature installs the OKF Wiki CLI and MCP server; it verifies a pinned checksum and the upstream cosign signature."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-11-04T14:49:59-06:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/features/okfw.mdx"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/okfw/devcontainer-feature.json"
    title: "okfw devcontainer-feature.json"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/tree/main/src/okfw/ansible-role-feature"
    title: "okfw Ansible role"
  - resource: "https://github.com/infrashift/okf-wiki/releases"
    title: "okf-wiki releases"
---

# Feature: okfw

The `okfw` feature installs `okfw`, the OKF Wiki CLI and MCP server, into `~/.local/bin`. The role installs the binary only after two checks pass: a pinned SHA256 checksum and the upstream cosign signature. It is the first role that verifies an upstream signature. The role then runs `okfw --version` and sends an MCP `initialize` request to `okfw mcp`.

## Options

Feature version 1.0.0. The defaults are from `src/okfw/devcontainer-feature.json` on 2026-11-04.

| Option | Default | Use |
|---|---|---|
| `target_version` | `2026.10.2` | The okfw release, without the leading `v`. |
| `target_checksum` | empty | Empty: use the pinned checksum. Required for a version that is not pinned. |

## Signature check

1. The role downloads the tarball and its sigstore bundle (`.sigstore.json`) from the GitHub release.
2. `get_url` verifies the tarball against the pinned checksum.
3. The role-local module `okfw_verify_blob` verifies the bundle against the release key. The key is pinned in `vars/main.yml`. The role never downloads `cosign.pub`.
4. The module rejects a bundle for a different file, a bundle from a different key, a keyless bundle and a DSSE envelope.

The module does the same check as `cosign verify-blob --key cosign.pub --insecure-ignore-tlog=true`. It uses the Python `cryptography` package. `ansible-core` depends on that package, so it is in the bootstrap venv. The base image has no `cosign` and no `openssl` command. Thus the feature needs no new download and no RPM, and it stays in the userland lane.

okf-wiki signs its releases offline and writes no Rekor entry. The pinned key and the pinned checksum are the trust root. A new release key upstream is a change to `vars/main.yml` and a new feature version.

## MCP server

The MCP server is the same binary: `okfw mcp`, on stdio. The feature does not write MCP client configuration. Each project registers the server in its own `.mcp.json`. This repository does that.

## Dependencies

* `dependsOn`: `./bootstrap`. The runtime installs [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) first ([ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md)).
* `installsAfter`: none.

## Test templates

The `extras` test template uses this feature. The contract tests include a signature failure: a validly signed bundle for a different file must stop the install before the role extracts the tarball. The maintainer container in `.devcontainer/` also installs the feature.

## Related

* [The roles do not verify upstream signatures of downloads](/issues/the-roles-do-not-verify-upstream-signatures-of-downloads--01a18382679b.md) — this feature is the first role that does.
* [ADR-006: Checksum verification](/decisions/adr-006-checksum-verification--01a183801256.md)
* [Role contract](/architecture/role-contract--01a1837fddd1.md) — the signature-bundle exemption.
* [Feature: cuelang](/features/feature-cuelang--01a183800db4.md) — the same pinned-checksum shape.
* [Features overview](/features/features-overview--01a1837af6b6.md)
