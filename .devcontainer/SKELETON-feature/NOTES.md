# SKELETON Feature

This is a template feature that demonstrates the canonical pattern for creating new devcontainer features.

## OS Support

This feature works on Red Hat UBI9/UBI10 and Fedora 43. `bash` is required to execute `install.sh`.
Feature installation is orchestrated by `/opt/bootstrap/run-feature.sh`, provided by the `bootstrap`
feature, which every trusted feature `dependsOn`.

## The parameter contract

**`devcontainer-feature.json` is the single source of truth for every option default. The Ansible role
has none.**

The chain is one-way, and each link is enforced:

```
devcontainer-feature.json  options.<id>.default
        |  materialized by the devcontainer CLI
        v
install.sh                 $TARGET_VERSION   -- guarded with ${VAR:?...}
        |  forwarded as an Ansible extra-var
        v
run-feature.sh             -e "_skeleton_version=..."
        |  extra-vars outrank role defaults
        v
tasks/main.yml             PARAMETER BRACKET asserts it arrived
```

A role default would sit at the bottom of Ansible's precedence order, below the extra-var that always
overrides it. It could therefore only take effect when the wiring above it is broken — turning a
missing option into a silently wrong value instead of an error. That is why `defaults/main.yml` is
empty in every role, and why derived values and constants live in `vars/main.yml` instead.

Three parameter classes, each validated differently:

| Class | Example | Assertion |
| --- | --- | --- |
| Mandatory | `target_version` | `${VAR:?}` in `install.sh`, then `is defined and \| length > 0` |
| Pass-through | `target_checksum` | `is defined` only — empty means "use the pinned map" |
| Enumerated | `color_choice` | `is defined and _color in ['blue','green','red']` |

Booleans arrive as the **string** `"true"`/`"false"` — `-e key=value` is always parsed as a string.
Assert membership and apply `| bool` at the point of use; never test a bare boolean var for truthiness.

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
3. Update `devcontainer-feature.json` with your feature metadata and options — **set every default
   here and nowhere else**
4. Update `install.sh`: the banner, a `${VAR:?...}` guard per mandatory option, and one `-e` per role
   parameter
5. Leave `ansible-role-feature/defaults/main.yml` empty — the role takes no defaults
6. Put derived values (tarball name, download URL, pinned checksum map) and role constants in
   `ansible-role-feature/vars/main.yml`, and update the compatibility list there
7. Update the PARAMETER BRACKET in `ansible-role-feature/tasks/main.yml` to assert your parameters,
   then implement the installation logic below it
8. Derive architecture from `_target_arch` (`amd64` | `arm64`). Never hardcode it, and never write
   `_target_arch | default('amd64')` — the mask hides a broken runner and installs the wrong binary
9. Update `ansible-role-feature/meta/main.yml` with your role metadata
10. Add the feature to a template under `test-templates/` so CI exercises it
