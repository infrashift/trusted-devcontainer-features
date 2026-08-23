---
title: Architecture
description: How Infrashift DevContainer Features work under the hood.
---

## Overview

Every feature is metadata plus an Ansible role. A single shared runner turns that into an installation. Features contain no imperative shell beyond a five-line wrapper.

## Base Image Pipeline

```
┌──────────────────────────────────────────┐
│  trusted/fedora43-minimal (digest pinned) │
├──────────────────────────────────────────┤
│  tar gzip curl util-linux                 │  feature prerequisites
│  unzip libicu openssl-libs                │  shared runtime libraries
│  procps-ng diffutils findutils less …     │  interactive baseline
│  Create dev user (1001:1001)              │
└──────────────────────────────────────────┘
                    │
                    ▼
┌──────────────────────────────────────────┐
│  bootstrap feature                        │
├──────────────────────────────────────────┤
│  /usr/local/bin/uv        pinned + SHA256 │
│  /opt/bootstrap/.bootstrap  venv:         │
│      pinned CPython + pinned ansible-core │
│  /opt/bootstrap/inventory.yml             │
│  /opt/bootstrap/site.yml                  │
│  /opt/bootstrap/run-feature.sh            │
│  /opt/bootstrap/tasks/                    │
└──────────────────────────────────────────┘
```

The base image is deliberately minimal, so anything features depend on is listed explicitly. `util-linux` (not `util-linux-core`) is required because only the full package ships `setpriv`.

`/opt/bootstrap` is **root-owned and world-readable**. The `dev` user executes the toolchain but cannot modify it — the account being provisioned cannot rewrite the thing doing the provisioning.

See [ADR-010](/trusted-devcontainer-features/decisions/adr-010-fedora-target/) and [ADR-008](/trusted-devcontainer-features/decisions/adr-008-pinned-bootstrap-environment/).

## Feature Install Pipeline

```
install.sh → /opt/bootstrap/run-feature.sh → site.yml → ansible-role-feature
```

### Stage 1: install.sh

Runs as root during the container build — that is fixed by the Dev Container specification. It is a thin wrapper containing no logic:

```bash
#!/usr/bin/env bash
set -euo pipefail
exec /opt/bootstrap/run-feature.sh \
    --role ansible-role-feature \
    -e "_cue_version=${TARGET_VERSION}"
```

Feature options arrive as uppercased environment variables and are forwarded as Ansible extra-vars using their role-internal underscore names, overriding `defaults/main.yml` directly.

### Stage 2: run-feature.sh

The shared runner selects the identity, then execs `ansible-playbook` from the pinned environment.

**Userland lane (default).** Drops from root to the target user before Ansible starts, so every file is created correctly owned. Roles need no `become`, no `owner`/`group`, and no `chown` repair.

De-escalation uses `setpriv`, not `su`/`runuser`: those authenticate through PAM, which fails during a container build with *"failed to establish user credentials"* because the build lacks the capabilities PAM requires.

**Privileged lane (`--privileged`).** Stays root, for features whose purpose is system state — `git`, `git-lfs`, `sudo`, `egress-filter`.

The runner also injects `_target_username`, `_target_user_home`, and `_target_arch`, and redirects `ANSIBLE_HOME`, `ANSIBLE_REMOTE_TMP`, and `ANSIBLE_LOCAL_TEMP` into `/tmp` so no Ansible scratch state lands in the developer's home.

### Stage 3: the role

`site.yml` is generic — it applies the one role named by `feature_role`. The role opens with a compatibility assert, installs, and verifies.

Roles must be **idempotent**: a second run reports `changed=0`. See [ADR-012](/trusted-devcontainer-features/decisions/adr-012-feature-role-contract/) for the full contract.

### System packages

Ansible's `package`/`dnf5` modules cannot be used. They import the `libdnf5` Python bindings, which exist only for the system interpreter — the isolated `.bootstrap` venv cannot see them. Privileged features therefore include a shared task file that shells out to `dnf5`, guarded by an `rpm -q` probe for idempotency:

```yaml
- name: Install system packages
  ansible.builtin.include_tasks: /opt/bootstrap/tasks/install-packages.yml
  vars:
    _packages:
      - git
```

Shared runtime libraries that userland tools merely link against (`unzip`, `libicu`, `openssl-libs`) live in the base image instead, which keeps `bun`, `openjdk`, and `dotnet` entirely userland.

## Directory Layout

```
src/
├── bootstrap/                       # provisions the shared environment
│   ├── devcontainer-feature.json
│   ├── install.sh                   # plain bash — it creates Ansible
│   └── assets/
│       ├── run-feature.sh
│       ├── site.yml
│       └── tasks/install-packages.yml
└── <feature-id>/
    ├── devcontainer-feature.json    # metadata, options, dependsOn
    ├── install.sh                   # ~5-line wrapper
    └── ansible-role-feature/
        ├── defaults/main.yml        # versions, URLs, pinned checksums
        ├── vars/main.yml            # variant compatibility list
        ├── meta/main.yml
        └── tasks/main.yml           # the installation
test-templates/
└── <name>/                          # integration test surface
```

There is no per-feature `hosts.yml` or `activate-feature.yml`. Inventory is generated once by the bootstrap feature; the playbook is shared.

## Installation Paths

Features install into user-scoped directories under the target user's home, resolved from `_REMOTE_USER_HOME` rather than hardcoded:

| Path | Purpose |
|------|---------|
| ``~/.local/bin`` | CLI binaries (jq, yq, grype, syft, cue, …) |
| ``~/.local/share/go`` | Go installation |
| ``~/.local/share/nodejs`` | Node.js installation |
| ``~/.local/share/java`` | OpenJDK installation |
| ``~/.local/share/dotnet`` | .NET SDK installation |
| ``~/.local/share/pnpm`` | pnpm home directory |
| ``~/.local/share/gopath`` | Go workspace (GOPATH) |
| ``~/.bun/bin`` | Bun global installs (Claude Code, OpenAI Codex) |

## Dependency Graph

Every feature declares `dependsOn` the bootstrap feature, so it is installed even if a template does not list it:

```
bootstrap ──→ (every feature)

bun ──→ claude-code
    └─→ openai-codex

nodejs ──→ npm
      └──→ pnpm

golang ──→ cuelang

uv-ruff ──→ python ──→ ansible-core

git ──→ git-lfs
```

`installsAfter` still expresses ordering between features that do not require each other's presence; `dependsOn` expresses mandatory inclusion. See [ADR-009](/trusted-devcontainer-features/decisions/adr-009-mandatory-dependencies/).

## Variant Detection

The container variant is detected **once**, by the bootstrap feature, from `/etc/os-release`, and published as a group variable in `/opt/bootstrap/inventory.yml`. Each role asserts the detected variant appears in its `_securedevcontainer_compatibility_list`.

Previously every feature shipped an inventory that hardcoded `localhost` into the `ubi9` group, so the assert compared `"ubi9"` against `["ubi9","ubi10"]` and passed regardless of the underlying image. See [ADR-010](/trusted-devcontainer-features/decisions/adr-010-fedora-target/).

## CI/CD Pipeline

Integration testing runs through `test-templates/`, each a real devcontainer combining several features against the shared Containerfile. `.github/workflows/test-templates.yaml` builds each template and runs its `tests.sh`.
