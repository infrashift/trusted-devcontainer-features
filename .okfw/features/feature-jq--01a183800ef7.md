---
id: "01a18380-0ef7-7ed2-8d03-7787901bc6b2"
title: "Feature: jq"
type: "feature"
tags:
  - "feature"
  - "jq"
created: "2026-10-28T12:12:50-05:00"
timestamp: "2026-10-28T12:17:21-05:00"
description: "The jq feature installs the jq binary from GitHub releases into ~/.local/bin, verified against a pinned SHA256 checksum."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:21-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/features/jq.mdx"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/jq/devcontainer-feature.json"
    title: "jq devcontainer-feature.json"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/tree/main/src/jq/ansible-role-feature"
    title: "jq Ansible role"
---

# Feature: jq

The `jq` feature installs the `jq` binary from the `jqlang/jq` GitHub releases into `~/.local/bin`. The role verifies the binary against a pinned SHA256 checksum. It verifies the install with `jq --version`, which prints `jq-<version>`.

## Options

Feature version 1.5.3. The defaults are from `src/jq/devcontainer-feature.json` on 2026-10-28.

| Option | Default | Use |
|---|---|---|
| `target_version` | `1.8.2` | The jq version. |
| `target_checksum` | empty | Empty: use the pinned checksum. Required for a version that has no pin. |

## Dependencies

* `dependsOn`: `./bootstrap`. The runtime installs [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) first ([ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md)).
* `installsAfter`: none.

## Test templates

The test templates `ansible-cue`, `dotnet-node`, `go-cue`, `java`, `python` in `test-templates/` use this feature.

## Related

* [On 2026-10-28, jq tags 1.4.0 to 1.5.1 resolve to the 1.5.2 build](/findings/on-2026-10-28-jq-tags-1-4-0-to-1-5-1-resolve-to-the-1-5-2-build--01a183826888.md)
* [Feature: yq](/features/feature-yq--01a18380115a.md)
* [ADR-006: Checksum verification](/decisions/adr-006-checksum-verification--01a183801256.md)
* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md) — the version assert for `jq`.
* [Features overview](/features/features-overview--01a1837af6b6.md)
