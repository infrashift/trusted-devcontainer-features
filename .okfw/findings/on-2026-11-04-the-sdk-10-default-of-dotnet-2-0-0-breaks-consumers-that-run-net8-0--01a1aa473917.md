---
id: "01a1aa47-3917-725d-b026-5d3a21efd16c"
title: "On 2026-11-04, the SDK 10 default of dotnet 2.0.0 breaks consumers that run net8.0"
type: "finding"
tags:
  - "finding"
  - "dotnet"
  - "sqlpackage"
  - "breaking-change"
created: "2026-11-04T23:55:56-06:00"
timestamp: "2026-11-04T23:55:56-06:00"
description: "dotnet 2.0.0 defaults to SDK 10.0.403, which has no 8.0 runtime, so net8.0 projects and 8.0 global.json pins fail unless target_version is 8.0.427."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-11-04T23:55:56-06:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/dotnet/devcontainer-feature.json"
sources:
  - resource: "https://builds.dotnet.microsoft.com/dotnet/release-metadata/10.0/releases.json"
    title: ".NET 10.0 release metadata"
  - resource: "https://builds.dotnet.microsoft.com/dotnet/release-metadata/8.0/releases.json"
    title: ".NET 8.0 release metadata"
  - resource: "https://api.nuget.org/v3-flatcontainer/microsoft.sqlpackage/170.5.76/microsoft.sqlpackage.nuspec"
    title: "microsoft.sqlpackage 170.5.76 nuspec"
---

# On 2026-11-04, the SDK 10 default of dotnet 2.0.0 breaks consumers that run net8.0

Version 2.0.0 of the `dotnet` feature changes the default `target_version` from `8.0.427` to `10.0.403`. SDK 10 contains only the 10.0 runtime. Thus a consumer that runs a `net8.0` project, and sets no `target_version`, has failures after the next rebuild.

## Source of the facts

* Microsoft release metadata, `https://builds.dotnet.microsoft.com/dotnet/release-metadata/<line>/releases.json`, read on 2026-11-04.
* NuGet nuspec files of `microsoft.sqlpackage`, read on 2026-11-04.
* A test in the `dotnet-node` template container with SDK `10.0.403`, on 2026-11-05.

## Facts

| Item | Value |
|---|---|
| Newest 10.0 SDK | `10.0.403` (runtime 10.0.14, released 2026-10-25). Support ends 2028-11-14. |
| Newest 8.0 SDK | `8.0.427`. Support ends 2026-11-10. |
| `microsoft.sqlpackage` 170.5.76 | Target frameworks `net10.0` and `net8.0` |
| `microsoft.sqlpackage` 170.4.83 | Target frameworks `net10.0` and `net8.0` |
| Docs reference | `docs/src/content/docs/getting-started.md` tells consumers to use the `:latest` tag |

## Consumers that break

1. A project that targets `net8.0` and runs code. SDK 10 builds the project. `dotnet run`, `dotnet test` and the built app stop because the 8.0 runtime is missing.
2. A repository with a `global.json` that pins an 8.0 SDK. Every `dotnet` command stops with "A compatible .NET SDK was not found".
3. A build that sets `TreatWarningsAsErrors`. SDK 10 adds analyzer warnings and NuGet audit warnings.

## Measured in the container

On 2026-11-05, the `dotnet-node` template container had SDK `10.0.403` and the runtime `Microsoft.NETCore.App 10.0.14` only.

| Test | Result |
|---|---|
| `dotnet build` of a `net8.0` console project | 0 errors |
| `dotnet run` of the same project | Exit code 150, "You must install or update .NET to run this application", "Framework: 'Microsoft.NETCore.App', version '8.0.0' (x64)" |
| `dotnet new console -f net8.0` | Fails. SDK 10 does not offer `net8.0` in the console template. |
| `sqlpackage /version` | `170.5.76.0` |

## Consumers that do not break

* A consumer that sets `target_version`.
* A consumer that references the `:1` tag. The major version change keeps `:1` on SDK 8.
* The `sqlpackage` feature at its default pin. `dotnet tool install` selects the `net10.0` asset on SDK 10.

## Analysis — not part of the record

* The major version 2.0.0 protects only consumers that reference `:1` or `:1.5`. Consumers that reference `:latest` get SDK 10. The docs tell consumers to use `:latest`, so most consumers get the change.
* To keep SDK 8, a consumer sets `target_version` to `8.0.427`. This is a short-term fix, because support for 8.0 stops on 2026-11-10.
* The correct fix for a consumer is to change the project target to `net10.0`.

## Related

* [Feature: dotnet](/features/feature-dotnet--01a183800dda.md)
* [Feature: sqlpackage](/features/feature-sqlpackage--01a1838010af.md)
* [Change a feature and bump its version](/operations/change-a-feature-and-bump-its-version--01a1837fe143.md)
* [Findings overview](/findings/findings-overview--01a1837af700.md)
