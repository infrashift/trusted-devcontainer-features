---
id: "01a18380-1108-74d6-ac28-95971477a236"
title: "Feature: syft"
type: "feature"
tags:
  - "feature"
  - "syft"
created: "2026-10-28T12:12:50-05:00"
timestamp: "2026-10-28T12:17:22-05:00"
description: "The syft feature installs the Anchore Syft SBOM generator; it verifies the tarball against the checksums file of the release."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:22-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/features/syft.mdx"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/syft/devcontainer-feature.json"
    title: "syft devcontainer-feature.json"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/tree/main/src/syft/ansible-role-feature"
    title: "syft Ansible role"
---

# Feature: syft

The `syft` feature installs the Anchore Syft SBOM generator into `~/.local/bin`. If `target_checksum` is empty, the role downloads the checksums file of the GitHub release and takes the SHA256 checksum of the tarball from it. The role has no pinned checksum. It verifies the install with `syft version`.

## Options

Feature version 1.6.0. The defaults are from `src/syft/devcontainer-feature.json` on 2026-10-28.

| Option | Default | Use |
|---|---|---|
| `target_version` | `1.55.0` | The Syft version. |
| `target_checksum` | empty | Empty: use the checksums file of the release. |

## Dependencies

* `dependsOn`: `./bootstrap`. The runtime installs [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) first ([ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md)).
* `installsAfter`: none.

## Test templates

The test templates `ansible-cue`, `dotnet-node`, `go-cue`, `java`, `python` in `test-templates/` use this feature.

## Related

* [Feature: grype](/features/feature-grype--01a183800ecb.md) — the same shape.
* [ADR-006: Checksum verification](/decisions/adr-006-checksum-verification--01a183801256.md)
* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md) — the checksums-file exemption.
* [Features overview](/features/features-overview--01a1837af6b6.md)
