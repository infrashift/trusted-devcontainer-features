---
id: "01a18380-1056-76fc-b683-086713164dc3"
title: "Feature: pnpm"
type: "feature"
tags:
  - "feature"
  - "pnpm"
created: "2026-10-28T12:12:50-05:00"
timestamp: "2026-10-28T12:17:21-05:00"
description: "The pnpm feature installs the pnpm standalone binary into ~/.local/bin, verified against a pinned SHA256 checksum."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:21-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/features/pnpm.mdx"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/pnpm/devcontainer-feature.json"
    title: "pnpm devcontainer-feature.json"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/tree/main/src/pnpm/ansible-role-feature"
    title: "pnpm Ansible role"
---

# Feature: pnpm

The `pnpm` feature installs the pnpm standalone binary from the `pnpm/pnpm` GitHub releases as `~/.local/bin/pnpm`. The role verifies it against a pinned SHA256 checksum. `containerEnv` sets `PNPM_HOME` to `/home/dev/.local/share/pnpm` and adds that directory to `PATH`.

## Options

Feature version 1.5.0. The defaults are from `src/pnpm/devcontainer-feature.json` on 2026-10-28.

| Option | Default | Use |
|---|---|---|
| `target_version` | `10.34.9` | The pnpm version. |
| `target_checksum` | empty | Empty: use the pinned checksum. Required for a version that has no pin. |

## Dependencies

* `dependsOn`: `./bootstrap`. The runtime installs [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) first ([ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md)).
* `installsAfter`: `./nodejs`. This sets the order only. It does not install the other feature.

## Test templates

The test template `dotnet-node` in `test-templates/` uses this feature.

## Notes

* The docs page says that the feature makes `~/.local/share/pnpm` and that the dependency installs Node.js automatically. The code writes to `~/.local/bin`, and `nodejs` is only in `installsAfter`.
* `containerEnv.PATH` has the literal `/home/dev`. [ADR-011: dev user alignment](/decisions/adr-011-dev-user-alignment--01a183801339.md) accepts a literal path in `containerEnv`.

## Related

* [The pnpm role cannot install pnpm 11 or later](/issues/the-pnpm-role-cannot-install-pnpm-11-or-later--01a1838266f1.md)
* [Four containerEnv values name /home/dev](/issues/four-containerenv-values-name-home-dev--01a183826729.md)
* [Feature: nodejs](/features/feature-nodejs--01a183800fa6.md)
* [ADR-006: Checksum verification](/decisions/adr-006-checksum-verification--01a183801256.md)
* [ADR-011: dev user alignment](/decisions/adr-011-dev-user-alignment--01a183801339.md)
* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
