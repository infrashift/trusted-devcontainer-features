# SKELETON Feature

This is a template feature that demonstrates the canonical pattern for creating new devcontainer features.

## OS Support

This feature works on Red Hat UBI9 and UBI10. `bash` is required to execute `install.sh`. Feature installation is orchestrated via `uv run --with ansible-core ansible-playbook`.

## Example Usage

*Accept default option values:*

```json
// devcontainer.json
"features": {
    "./SKELETON-feature": {}
}
```

*Specify option values:*

```json
// devcontainer.json
"features": {
    "./SKELETON-feature": {"color_choice": "blue", "is_my_favorite_color": true}
}
```

## Creating a New Feature

1. Copy the entire `SKELETON-feature/` directory
2. Rename to `<your-feature-name>-feature/`
3. Update `devcontainer-feature.json` with your feature metadata and options
4. Update `install.sh` banner and extra vars
5. Update `activate-feature.yml` with your role vars
6. Implement your installation logic in `ansible-role-feature/tasks/main.yml`
7. Set default versions/paths in `ansible-role-feature/defaults/main.yml`
8. Update compatibility list in `ansible-role-feature/vars/main.yml`
9. Update `ansible-role-feature/meta/main.yml` with role metadata
