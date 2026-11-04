---
id: "01a18380-0db4-77a5-a524-0e4f00d5e9a5"
title: "Feature: cuelang"
type: "feature"
tags:
  - "feature"
  - "cuelang"
created: "2026-10-28T12:12:49-05:00"
timestamp: "2026-10-28T12:17:21-05:00"
description: "The cuelang feature installs the cue command from a GitHub release tarball, verified against a pinned SHA256 checksum."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:21-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/features/cuelang.mdx"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/cuelang/devcontainer-feature.json"
    title: "cuelang devcontainer-feature.json"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/tree/main/src/cuelang/ansible-role-feature"
    title: "cuelang Ansible role"
---

# Feature: cuelang

The `cuelang` feature installs the `cue` command. The role downloads the release tarball from `github.com/cue-lang/cue` and verifies it against a pinned SHA256 checksum. It extracts `cue` into `~/.local/share/cue` and links it into `~/.local/bin`. Before [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md), this role downloaded with no checksum ([ADR-006: Checksum verification](/decisions/adr-006-checksum-verification--01a183801256.md)).

## Options

Feature version 1.5.3. The defaults are from `src/cuelang/devcontainer-feature.json` on 2026-10-28.

| Option | Default | Use |
|---|---|---|
| `target_version` | `0.17.1` | The CUE version. |
| `target_checksum` | empty | Empty: use the pinned checksum. Required for a version that has no pin. |

## Dependencies

* `dependsOn`: `./bootstrap`. The runtime installs [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) first ([ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md)).
* `installsAfter`: `./golang`. This sets the order only. It does not install the other feature.

## Test templates

The test templates `ansible-cue`, `go-cue` in `test-templates/` use this feature.

## Notes

* The docs page says that CUE depends on Go. In the code, `golang` is only in `installsAfter`, and `cue` is a static binary.

## Related

* [Feature: golang](/features/feature-golang--01a183800e75.md)
* [ADR-006: Checksum verification](/decisions/adr-006-checksum-verification--01a183801256.md) — the amendment names this role.
* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
