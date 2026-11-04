---
id: "01a18380-115a-7806-a639-2c8c310d5fb9"
title: "Feature: yq"
type: "feature"
tags:
  - "feature"
  - "yq"
created: "2026-10-28T12:12:50-05:00"
timestamp: "2026-10-28T12:17:22-05:00"
description: "The yq feature installs the yq binary from GitHub releases into ~/.local/bin, verified against a pinned SHA256 checksum."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:22-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/features/yq.mdx"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/yq/devcontainer-feature.json"
    title: "yq devcontainer-feature.json"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/tree/main/src/yq/ansible-role-feature"
    title: "yq Ansible role"
---

# Feature: yq

The `yq` feature installs the `yq` binary from the `mikefarah/yq` GitHub releases into `~/.local/bin`. The role verifies the binary against a pinned SHA256 checksum. The checksums file of yq is a table with 20 columns, so the role pins the checksums and does not parse that file.

## Options

Feature version 1.6.0. The defaults are from `src/yq/devcontainer-feature.json` on 2026-10-28.

| Option | Default | Use |
|---|---|---|
| `target_version` | `4.54.1` | The yq version. |
| `target_checksum` | empty | Empty: use the pinned checksum. Required for a version that has no pin. |

## Dependencies

* `dependsOn`: `./bootstrap`. The runtime installs [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) first ([ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md)).
* `installsAfter`: none.

## Test templates

The test templates `ansible-cue`, `dotnet-node`, `go-cue`, `java`, `python` in `test-templates/` use this feature.

## Notes

* [ADR-006: Checksum verification](/decisions/adr-006-checksum-verification--01a183801256.md) says that the role uses the checksums file of the release. The code now uses a pinned checksum.

## Related

* [Feature: jq](/features/feature-jq--01a183800ef7.md)
* [ADR-006: Checksum verification](/decisions/adr-006-checksum-verification--01a183801256.md)
* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
