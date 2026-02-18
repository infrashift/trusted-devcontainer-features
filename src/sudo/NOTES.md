# sudo Feature

Installs sudo and configures passwordless sudo for the devcontainer user on Red Hat UBI DevContainers.

## OS Support

Red Hat UBI9 and UBI10. Feature installation is orchestrated via `uv run --with ansible-core ansible-playbook`.

## Example Usage

```json
// devcontainer.json
"features": {
    "./sudo-feature": {}
}
```
