# OpenJDK Feature

Installs [Eclipse Temurin](https://adoptium.net/) OpenJDK.

## Install Location

- JDK: `~/.local/share/java/`
- `JAVA_HOME` set via containerEnv

## System Dependencies

- `libicu` and `openssl-libs` (installed via dnf)

## Versions

See available versions at https://adoptium.net/temurin/releases/

## Notes

- URL requires `+` encoded as `%2B` in the version string
- `java -version` outputs to stderr; assertions check both stdout and stderr
- UBI9/UBI10 only
