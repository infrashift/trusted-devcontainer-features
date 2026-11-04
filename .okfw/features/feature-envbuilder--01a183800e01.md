---
id: "01a18380-0e01-7124-b865-93e938cf574c"
title: "Feature: envbuilder"
type: "feature"
tags:
  - "feature"
  - "envbuilder"
created: "2026-10-28T12:12:49-05:00"
timestamp: "2026-10-28T12:17:21-05:00"
description: "The envbuilder feature downloads the single image layer of Coder envbuilder from the registry; the pinned layer digest is the URL and the checksum."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:21-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/features/envbuilder.mdx"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/envbuilder/devcontainer-feature.json"
    title: "envbuilder devcontainer-feature.json"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/tree/main/src/envbuilder/ansible-role-feature"
    title: "envbuilder Ansible role"
---

# Feature: envbuilder

The `envbuilder` feature installs Coder envbuilder, which builds a dev container from a repository inside a container. envbuilder has no release binaries, so the role downloads the single layer of the `ghcr.io/coder/envbuilder` image as an OCI blob. The pinned layer digest is both the download URL and the checksum. The binary goes into `~/.local/share/envbuilder/<version>/` with a link in `~/.local/bin`.

## Options

Feature version 1.1.2. The defaults are from `src/envbuilder/devcontainer-feature.json` on 2026-10-28.

| Option | Default | Use |
|---|---|---|
| `target_version` | `1.3.0` | The envbuilder version. |
| `target_checksum` | empty | Empty: use the pinned layer digest. Required for a version that has no pin. |

The role does not run the binary to verify it. `envbuilder version` starts a build. The role checks the versioned path instead.

## Dependencies

* `dependsOn`: `./bootstrap`. The runtime installs [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) first ([ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md)).
* `installsAfter`: none.

## Test templates

The test template `infra` in `test-templates/` uses this feature.

## Related

* [Feature: kaniko](/features/feature-kaniko--01a183800f23.md) — the same layer-download shape.
* [ADR-006: Checksum verification](/decisions/adr-006-checksum-verification--01a183801256.md)
* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
