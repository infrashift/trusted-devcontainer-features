---
title: Contributing
description: How to add new features and contribute to the project.
---

## Adding a New Feature

Start by copying `.devcontainer/SKELETON-feature/`. It is the canonical shape and already encodes the contract below.

### 1. Create the Feature Directory

```
src/my-feature/
├── devcontainer-feature.json
├── install.sh
└── ansible-role-feature/
    ├── defaults/main.yml
    ├── vars/main.yml
    ├── meta/main.yml
    └── tasks/main.yml
```

There is no `hosts.yml` and no `activate-feature.yml`. Inventory is generated once by the `bootstrap` feature, and `site.yml` is shared.

### 2. Define Feature Metadata

```jsonc
{
    "name": "my-feature",
    "id": "my-feature",
    "version": "1.0.0",
    "description": "Installs My Tool on trusted DevContainers.",
    "options": {
        "target_version": {
            "type": "string",
            "default": "1.0.0",
            "description": "Select the version to install"
        },
        "target_checksum": {
            "type": "string",
            "default": "",
            "description": "SHA256 of the release archive. Required for non-default versions."
        }
    },
    "installsAfter": [],
    "dependsOn": {
        "./bootstrap": {}
    }
}
```

`dependsOn` the bootstrap feature is **mandatory** — it provides the runner. `installsAfter` remains for ordering against features you do not require.

Avoid `containerEnv` entries with hardcoded home directories where you can. `~/.local/bin` is already on `PATH` via the base image.

### 3. Write install.sh

The whole script:

```bash
#!/usr/bin/env bash
set -euo pipefail

exec /opt/bootstrap/run-feature.sh \
    --role ansible-role-feature \
    -e "_my_tool_version=${TARGET_VERSION}" \
    -e "_my_tool_checksum=${TARGET_CHECKSUM:-}"
```

Put no logic here. Variables are passed with their role-internal underscore names so they override `defaults/main.yml` directly.

Add `--privileged` **only** if the feature's purpose is system state (installing an RPM, writing to `/etc`). Everything that installs into the user's home stays in the default userland lane.

:::caution
An extra-var has the highest precedence in Ansible and **cannot be overridden by `set_fact`**. If your role resolves a value at runtime — for example parsing a checksum out of an upstream checksums file — the input and the resolved value must be different names (`_my_tool_checksum` and `_my_tool_effective_checksum`).
:::

### 4. Write the Role

`vars/main.yml` lists the variants you have actually tested:

```yaml
_securedevcontainer_compatibility_list:
  - ubi9
  - ubi10
  - fedora43
```

`tasks/main.yml` opens with the compatibility assert, then installs. The runner injects `_target_username`, `_target_user_home`, and `_target_arch`.

**Idempotency is required** — a second run must report `changed=0`:

- Probe the installed version first, and gate install work on a needs-install fact.
- Download with `get_url` **and a `checksum:` argument**. Never download unverified.
- Guard `unarchive` behind that fact, or use `creates:`.
- Never use `command` without `creates:` or an accurate `changed_when:`.
- Probes use `failed_when: false` + `changed_when: false`, not `ignore_errors: true`.
- Do **not** set `owner`/`group` and do not `chown`. The playbook already runs as the target user.
- Derive architecture from `_target_arch` (`amd64`/`arm64`). Never hardcode.

For system packages, include the shared task file rather than using the `package` module, which cannot work from the isolated venv:

```yaml
- name: Install system packages
  ansible.builtin.include_tasks: /opt/bootstrap/tasks/install-packages.yml
  vars:
    _packages:
      - my-rpm
```

### 5. Add Integration Tests

Features are tested through `test-templates/`. Add your feature to an existing template's `devcontainer.json`, or create a new template, and assert against it in that template's `tests.sh`.

## Running Tests Locally

```bash
# Contract check first — it is seconds of CPU and catches most mistakes
# before you spend minutes on a container build.
make check-contract

# Then build the template your feature belongs to and test it.
make test-template TEMPLATE=<template>
make test-contract TEMPLATE=<template>
```

`make check-contract` will tell you if your feature drifts from the contract: a value left in `defaults/main.yml`, a missing assert bracket, an option without a default, a mandatory option lacking its `${VAR:?}` guard, or an `-e` in `install.sh` with no matching assertion.

`make test-contract` re-runs each role and requires `changed=0`, then checks that a missing parameter, an empty mandatory option, an unpinned version and a bad digest each fail by name. Add your feature to `ROLE_ARGS` in `test-templates/shared/contract-tests.sh` so it is covered — the script prints `SKIP` for anything missing rather than silently passing.

## Code Style

- **install.sh**: `set -euo pipefail`, then `exec` the runner. Nothing else.
- **Roles**: explicit task names; `ansible.builtin.*` fully qualified.
- **Options**: `target_version` for pinning, `target_checksum` for SHA256 verification.
- **Paths**: install to `~/.local/bin` or `~/.local/share/<tool>`, resolved from `_target_user_home`.
