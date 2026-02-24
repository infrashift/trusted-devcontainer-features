---
title: Getting Started
description: How to add Infrashift DevContainer Features to your project.
---

## Prerequisites

- A container runtime: [Docker Desktop](https://www.docker.com/products/docker-desktop/), [Podman](https://podman.io/), or [Rancher Desktop](https://rancherdesktop.io/)
- [VS Code](https://code.visualstudio.com/) with the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers), or a Dev Container CLI
- A Red Hat UBI 9 base image (the features are designed for UBI, not Alpine or Debian)

## Adding a feature

Each feature is published to the GitHub Container Registry. Add features to your `devcontainer.json`:

```jsonc
{
    "image": "registry.access.redhat.com/ubi9/ubi:latest",
    "features": {
        "ghcr.io/infrashift/trusted-devcontainer-features/git:latest": {},
        "ghcr.io/infrashift/trusted-devcontainer-features/nodejs:latest": {
            "target_version": "22.16.0"
        },
        "ghcr.io/infrashift/trusted-devcontainer-features/python:latest": {
            "target_version": "3.12"
        }
    }
}
```

## Configuring options

Most features accept options to pin versions or provide checksums. Check each feature's reference page for available options.

```jsonc
{
    "features": {
        "ghcr.io/infrashift/trusted-devcontainer-features/golang:latest": {
            "target_version": "1.26.0",
            "target_checksum": "aac1b08a0fb0c4e0a7c1555beb7b59180b05dfc5a3d62e40e9de90cd42f88235"
        }
    }
}
```

## Dependency ordering

Some features depend on others. The Dev Container runtime handles ordering automatically via `installsAfter` declarations. Key dependency chains:

| Feature | Depends On |
|---------|-----------|
| `git-lfs` | `git` |
| `npm`, `pnpm` | `nodejs` |
| `python` | `uv-ruff` |
| `ansible-core` | `python` |
| `cuelang` | `golang` |
| `claude-code`, `openai-codex` | `bun` |

You don't need to worry about installation order — just declare the features you need and the runtime resolves the dependency graph.

## Using a UBI9 base image

These features are designed for Red Hat UBI 9. For the best experience, use a Containerfile that sets up a non-root `vscode` user:

```dockerfile
FROM registry.access.redhat.com/ubi9/ubi:latest

RUN groupadd --gid 1000 vscode \
    && useradd -m -s /bin/bash --uid 1000 --gid 1000 vscode

# UV is required as the feature bootstrapper
RUN curl -LsSf https://astral.sh/uv/install.sh | env INSTALLER_NO_MODIFY_PATH=1 UV_INSTALL_DIR=/usr/local/bin sh
```

## Local testing

Use the provided Makefile to test features locally:

```bash
# Test a single feature
make test-feature FEATURE=jq

# Test scenarios for a feature with dependencies
make test-scenarios FEATURE=claude-code

# Run all tests
make test
```

## Next steps

- Browse the [Feature Inventory](/trusted-devcontainer-features/features/) for the full list of available features
- Read about [AI-Powered DevContainers](/trusted-devcontainer-features/ai-support/) for Claude Code and OpenAI Codex setup
- Check the [Architecture](/trusted-devcontainer-features/reference/architecture/) for how features work under the hood
