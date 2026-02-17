# .NET SDK Feature

Installs [Microsoft .NET SDK](https://dotnet.microsoft.com/).

## Install Location

- SDK: `~/.local/share/dotnet/`
- `DOTNET_ROOT` set via containerEnv
- Telemetry opt-out enabled by default

## System Dependencies

- `libicu` and `openssl-libs` (installed via dnf)

## Versions

See available versions at https://dotnet.microsoft.com/download/dotnet

## Notes

- UBI9/UBI10 only
- LTS version 8.0 supported through November 2026
