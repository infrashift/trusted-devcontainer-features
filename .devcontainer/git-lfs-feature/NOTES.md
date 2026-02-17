# Git LFS Feature

Installs Git LFS via dnf on Red Hat UBI DevContainers.

## OS Support

Red Hat UBI9 and UBI10. Feature installation is orchestrated via `uv run --with ansible-core ansible-playbook`.

## Example Usage

```json
// devcontainer.json
"features": {
    "./git-lfs-feature": {}
}
```
