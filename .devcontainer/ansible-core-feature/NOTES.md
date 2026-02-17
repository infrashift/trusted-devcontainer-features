# ansible-core Feature

Installs [ansible-core](https://pypi.org/project/ansible-core/) via `uv tool install` on Red Hat UBI DevContainers.

## Install Location

- Ansible binaries (`ansible`, `ansible-playbook`, etc.): `~/.local/bin/`
- Managed venv: `~/.local/share/uv/tools/ansible-core/`

## OS Support

Red Hat UBI9 and UBI10. Feature installation is orchestrated via `uv run --with ansible-core ansible-playbook`.

## Prerequisites

- Python must be installed (use `python-feature` first)
- UV must be available (from `uv-ruff-feature` or the bootstrap uv in `/usr/local/bin`)

## Versions

See available versions at https://pypi.org/project/ansible-core/

## Example Usage

```json
// devcontainer.json
"features": {
    "./python-feature": {"target_version": "3.12"},
    "./ansible-core-feature": {
        "target_version": "2.18.2",
        "target_python_version": "3.12"
    }
}
```
