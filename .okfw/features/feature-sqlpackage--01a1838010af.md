---
id: "01a18380-10af-7433-b244-7595bd25e5c4"
title: "Feature: sqlpackage"
type: "feature"
tags:
  - "feature"
  - "sqlpackage"
  - "dotnet"
created: "2026-10-28T12:12:50-05:00"
timestamp: "2026-11-04T12:00:00-06:00"
description: "The sqlpackage feature installs SqlPackage as a .NET tool from NuGet; it needs the .NET SDK of the dotnet feature."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-11-04T12:00:00-06:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/features/sqlpackage.mdx"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/sqlpackage/devcontainer-feature.json"
    title: "sqlpackage devcontainer-feature.json"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/tree/main/src/sqlpackage/ansible-role-feature"
    title: "sqlpackage Ansible role"
---

# Feature: sqlpackage

The `sqlpackage` feature installs SqlPackage, the DacFx command line, as a .NET tool. The role runs `dotnet tool install microsoft.sqlpackage` with `--tool-path ~/.local/share/sqlpackage` and links `sqlpackage` into `~/.local/bin`. NuGet resolves and verifies the package, so the role has no pinned checksum. The exact version and a version assert replace it.

## Options

Feature version 1.0.5. The defaults are from `src/sqlpackage/devcontainer-feature.json` on 2026-11-04.

| Option | Default | Use |
|---|---|---|
| `target_version` | `170.5.76` | The SqlPackage version. It must publish a `net10.0` asset and a `net8.0` asset. |

## Dependencies

* `dependsOn`: `./bootstrap`. The runtime installs [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) first ([ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md)).
* `installsAfter`: `./dotnet`. This sets the order only. It does not install the other feature.
* `dotnet tool install` selects the highest target framework that the installed SDK supports: `net10.0` on SDK 10, `net8.0` on SDK 8.
* The role needs the .NET SDK at `~/.local/share/dotnet/dotnet`. It stops with an error if the SDK is missing. Add the `dotnet` feature in `devcontainer.json`, because `installsAfter` does not install it.

## Test templates

The test template `dotnet-node` in `test-templates/` uses this feature.

## Related

* [Four containerEnv values name /home/dev](/issues/four-containerenv-values-name-home-dev--01a183826729.md)
* [The sqlpackage feature could not find the .NET runtime](/issues/the-sqlpackage-feature-could-not-find-the-net-runtime--01a183826142.md)
* [Feature: dotnet](/features/feature-dotnet--01a183800dda.md)
* [ADR-006: Checksum verification](/decisions/adr-006-checksum-verification--01a183801256.md)
* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
