---
id: "01a18380-0dda-7727-886e-ea9e88814458"
title: "Feature: dotnet"
type: "feature"
tags:
  - "feature"
  - "dotnet"
created: "2026-10-28T12:12:49-05:00"
timestamp: "2026-10-28T12:17:21-05:00"
description: "The dotnet feature installs the .NET SDK from the Microsoft CDN in ~/.local/share/dotnet, verified against a pinned SHA512 checksum."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:21-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/features/dotnet.mdx"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/dotnet/devcontainer-feature.json"
    title: "dotnet devcontainer-feature.json"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/tree/main/src/dotnet/ansible-role-feature"
    title: "dotnet Ansible role"
---

# Feature: dotnet

The `dotnet` feature installs the .NET SDK from `builds.dotnet.microsoft.com` into `~/.local/share/dotnet`. The role verifies the tarball against a pinned SHA512 checksum, because Microsoft publishes SHA512 only. It links `dotnet` into `~/.local/bin`. `containerEnv` sets `DOTNET_ROOT` and `DOTNET_CLI_TELEMETRY_OPTOUT=1`.

## Options

Feature version 1.5.4. The defaults are from `src/dotnet/devcontainer-feature.json` on 2026-10-28.

| Option | Default | Use |
|---|---|---|
| `target_version` | `8.0.427` | The .NET SDK version. |
| `target_checksum` | empty | Empty: use the pinned SHA512 checksum (128 hex characters). |

## Dependencies

* `dependsOn`: `./bootstrap`. The runtime installs [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) first ([ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md)).
* `installsAfter`: none.

## Test templates

The test template `dotnet-node` in `test-templates/` uses this feature.

## Notes

* `containerEnv.DOTNET_ROOT` is the literal `/home/dev/.local/share/dotnet`. [ADR-011: dev user alignment](/decisions/adr-011-dev-user-alignment--01a183801339.md) accepts a literal path in `containerEnv`.
* The docs page says that the role adds `~/.local/share/dotnet` to `PATH`. The code links `dotnet` into `~/.local/bin` instead.

## Related

* [Four containerEnv values name /home/dev](/issues/four-containerenv-values-name-home-dev--01a183826729.md)
* [Feature: sqlpackage](/features/feature-sqlpackage--01a1838010af.md) — needs this SDK.
* [ADR-006: Checksum verification](/decisions/adr-006-checksum-verification--01a183801256.md)
* [ADR-011: dev user alignment](/decisions/adr-011-dev-user-alignment--01a183801339.md)
* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
