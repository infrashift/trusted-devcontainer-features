# CUElang Feature

Installs [CUE](https://cuelang.org/) on Red Hat UBI DevContainers.

## Install Location

- CUE: `~/.local/share/cue/`
- Symlink: `~/.local/bin/cue`

## OS Support

Red Hat UBI9 and UBI10. Feature installation is orchestrated via `uv run --with ansible-core ansible-playbook`.

## Versions

See available versions at https://github.com/cue-lang/cue/releases

## Example Usage

```json
// devcontainer.json
"features": {
    "./cuelang-feature": {"target_version": "0.15.4"}
}
```
