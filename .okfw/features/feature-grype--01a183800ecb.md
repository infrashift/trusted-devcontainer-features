---
id: "01a18380-0ecb-7569-8836-8dc72a274c87"
title: "Feature: grype"
type: "feature"
tags:
  - "feature"
  - "grype"
created: "2026-10-28T12:12:50-05:00"
timestamp: "2026-10-28T12:17:21-05:00"
description: "The grype feature installs the Anchore Grype scanner; it verifies the tarball against the checksums file of the release."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:21-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/features/grype.mdx"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/grype/devcontainer-feature.json"
    title: "grype devcontainer-feature.json"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/tree/main/src/grype/ansible-role-feature"
    title: "grype Ansible role"
---

# Feature: grype

The `grype` feature installs the Anchore Grype vulnerability scanner into `~/.local/bin`. If `target_checksum` is empty, the role downloads the checksums file of the GitHub release and takes the SHA256 checksum of the tarball from it. The role has no pinned checksum. It verifies the install with `grype version`.

## Options

Feature version 1.6.0. The defaults are from `src/grype/devcontainer-feature.json` on 2026-10-28.

| Option | Default | Use |
|---|---|---|
| `target_version` | `0.121.0` | The Grype version. |
| `target_checksum` | empty | Empty: use the checksums file of the release. |

## Dependencies

* `dependsOn`: `./bootstrap`. The runtime installs [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) first ([ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md)).
* `installsAfter`: none.

## Test templates

The test templates `ansible-cue`, `dotnet-node`, `go-cue`, `java`, `python` in `test-templates/` use this feature.

## Related

* [Feature: syft](/features/feature-syft--01a183801108.md) — the same shape.
* [ADR-006: Checksum verification](/decisions/adr-006-checksum-verification--01a183801256.md)
* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md) — the checksums-file exemption.
* [Features overview](/features/features-overview--01a1837af6b6.md)
