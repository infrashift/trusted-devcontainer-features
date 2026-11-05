# .NET SDK Feature

Installs [Microsoft .NET SDK](https://dotnet.microsoft.com/).

## Install Location

- SDK: `~/.local/share/dotnet/`, with `dotnet` linked into `~/.local/bin`
- `DOTNET_ROOT` set via containerEnv
- Telemetry opt-out enabled by default

## System Dependencies

- `libicu` and `openssl-libs`, supplied by the template base image

## Versions

The role pins a SHA512 for one patch on each supported SDK line:

| Line | Pinned version | Status |
|---|---|---|
| 10.0 | `10.0.403` | **Default.** LTS, supported until 2028-11-14 |
| 8.0 | `8.0.427` | Opt-in. LTS, support ends 2026-11-10 |

To keep SDK 8:

```jsonc
"features": {
    "ghcr.io/infrashift/trusted-devcontainer-features/dotnet:2": {
        "target_version": "8.0.427"
    }
}
```

Another version needs `target_checksum` (the SHA512 from
`<download_url>.sha512`), or the role stops before it downloads.

See available versions at https://dotnet.microsoft.com/download/dotnet

## Upgrading from 1.x (default SDK 8 → SDK 10)

Feature 2.0.0 changes the default from `8.0.427` to `10.0.403`. A consumer that
sets no `target_version` and references `:latest` or `:2` gets SDK 10 on the next
rebuild. A consumer pinned to `:1` keeps SDK 8.

What breaks under SDK 10:

- **A project that runs on `net8.0`.** SDK 10 builds it, but carries only the
  10.0 runtime, so `dotnet run`, `dotnet test` and the built app exit 150 with
  `You must install or update .NET to run this application` and
  `Framework: 'Microsoft.NETCore.App', version '8.0.0' (x64)`. On SDK 10,
  `dotnet new console -f net8.0` also fails: create the project, then change
  `<TargetFramework>`.
  Retarget to `net10.0`, set `<RollForward>Major</RollForward>`, or pin
  `target_version` to `8.0.427`.
- **A `global.json` that pins an 8.0 SDK.** With the default
  `rollForward: latestPatch`, every `dotnet` command fails with
  `A compatible .NET SDK was not found`.
- **Builds with `TreatWarningsAsErrors`.** SDK 10 adds analyzer and NuGet audit
  warnings.

## Notes

- UBI9, UBI10 and Fedora 43
- The `sqlpackage` feature works on either line: its pinned package ships
  `net10.0` and `net8.0` assets, and `dotnet tool install` picks the one that
  matches the SDK.
