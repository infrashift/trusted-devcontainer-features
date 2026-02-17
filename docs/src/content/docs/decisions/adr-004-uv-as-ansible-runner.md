---
title: "ADR-004: UV as Ansible Runner"
description: Decision to use UV's ephemeral environment to run Ansible without pre-installing it.
---

**Status:** Accepted

## Context

Using Ansible as the feature bootstrapper (ADR-002) requires ansible-core to be available during `install.sh` execution. Pre-installing ansible-core in the base image adds size and creates a chicken-and-egg problem — ansible-core itself is a feature we want to manage.

We needed a way to run Ansible playbooks without permanently installing ansible-core in the base image.

## Decision

Install UV (Astral's Python package manager) in the base Containerfile. Each feature's `install.sh` runs Ansible via `uv run --with ansible-core ansible-playbook`, which creates an ephemeral virtual environment, installs ansible-core into it, runs the playbook, and discards the environment. UV is fast enough (~2-3 seconds to resolve and install ansible-core) that this overhead is acceptable.

## Consequences

- **Positive**: No permanent ansible-core installation in the base image. Only UV (~15MB) is needed.
- **Positive**: Each feature runs with a clean, isolated ansible-core environment — no version conflicts.
- **Positive**: UV's dependency resolution is fast, keeping feature install times reasonable.
- **Negative**: Every feature install pays the cost of resolving and installing ansible-core into a temporary venv.
- **Negative**: Requires UV to be pre-installed in the base image as a bootstrap dependency.

## Alternatives Considered

- **Pre-install ansible-core in base image**: Rejected. Adds permanent image bloat and version management complexity.
- **pip install ansible-core in install.sh**: Rejected. Slower than UV and requires pip to be available.
- **pipx**: Rejected. UV provides the same ephemeral execution capability with faster resolution.
