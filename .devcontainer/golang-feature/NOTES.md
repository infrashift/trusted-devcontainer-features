# Golang Feature

Installs [Go](https://go.dev/) on Red Hat UBI DevContainers.

## Install Location

- Go SDK: `~/.local/share/go/`
- GOPATH: `~/.local/share/gopath/`

## OS Support

Red Hat UBI9 and UBI10. Feature installation is orchestrated via `uv run --with ansible-core ansible-playbook`.

## Versions

See available versions at https://go.dev/dl/

## Example Usage

```json
// devcontainer.json
"features": {
    "./golang-feature": {
        "target_version": "1.26.0",
        "target_checksum": "aac1b08a0fb0c4e0a7c1555beb7b59180b05dfc5a3d62e40e9de90cd42f88235"
    }
}
```
