---
title: Contributing
description: How to add new features and contribute to the project.
---

## Adding a New Feature

### 1. Create the Feature Directory

Create a new directory under ``src/`` with your feature ID:

```
src/my-feature/
├── devcontainer-feature.json
├── install.sh
├── activate-feature.yml
└── hosts.yml
```

### 2. Define Feature Metadata

Create ``devcontainer-feature.json`` with your feature's metadata:

```jsonc
{
    "name": "my-feature",
    "id": "my-feature",
    "version": "1.0.0",
    "description": "Installs My Tool on Red Hat UBI DevContainers.",
    "options": {
        "target_version": {
            "type": "string",
            "default": "1.0.0",
            "description": "Select the version to install"
        }
    },
    "containerEnv": {
        "PATH": "/home/vscode/.local/bin:${PATH}"
    },
    "installsAfter": []
}
```

### 3. Write the Install Script

Create ``install.sh`` following the standard pattern:

```bash
#!/usr/bin/env bash
set -euo pipefail

FEATURE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Validate UV is available
command -v uv >/dev/null 2>&1 || { echo "ERROR: uv is not installed"; exit 1; }

# Run Ansible playbook
uv run --with ansible-core \
    ansible-playbook "${FEATURE_DIR}/activate-feature.yml" \
    -i "${FEATURE_DIR}/hosts.yml" \
    -e "my_tool_version=${TARGET_VERSION:-1.0.0}"
```

### 4. Write the Ansible Playbook

Create ``activate-feature.yml`` with the installation tasks. Use Ansible modules for downloading, extracting, and configuring the tool.

### 5. Create the Ansible Inventory

Create ``hosts.yml``:

```yaml
all:
  hosts:
    localhost:
      ansible_connection: local
```

### 6. Add Tests

Create test files under ``test/my-feature/``:

```bash
#!/bin/bash
# test/my-feature/test.sh
set -e
source dev-container-features-test-lib

check "my-tool is installed" bash -c "my-tool --version"

reportResults
```

### 7. Update the CI Matrix

Add your feature to the test matrix in ``.github/workflows/test-all.yaml``.

## Running Tests Locally

```bash
# Build the base image
make build-test-base

# Test your feature
make test-feature FEATURE=my-feature

# Test scenarios (if applicable)
make test-scenarios FEATURE=my-feature
```

## Code Style

- **install.sh**: Use ``set -euo pipefail``, validate inputs, and delegate to Ansible
- **Ansible playbooks**: Use YAML style with explicit task names
- **Options**: Use ``target_version`` for version pinning, ``target_checksum`` for SHA256 verification
- **Paths**: Install to ``~/.local/bin`` or ``~/.local/share/<tool>``
