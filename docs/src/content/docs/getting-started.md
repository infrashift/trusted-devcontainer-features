---
title: Getting Started
description: How to add Infrashift DevContainer Features to your project.
---

## Prerequisites

- A container runtime: [Docker Desktop](https://www.docker.com/products/docker-desktop/), [Podman](https://podman.io/), or [Rancher Desktop](https://rancherdesktop.io/)
- [VS Code](https://code.visualstudio.com/) with the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers), or a Dev Container CLI
- A trusted Fedora 43 or UBI base image (the features target RPM-based images, not Alpine or Debian)

## Adding a feature

Each feature is published to the GitHub Container Registry. Add features to your `devcontainer.json`:

```jsonc
{
    "image": "ghcr.io/infrashift/trusted-base-images/trusted/fedora43-minimal:latest",
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

Most features accept options to pin versions. Check each feature's reference page for available options.

```jsonc
{
    "features": {
        "ghcr.io/infrashift/trusted-devcontainer-features/golang:latest": {
            "target_version": "1.26.0"
        }
    }
}
```

You do not normally pass a checksum. Each role pins a SHA256 per version *and* per architecture, so
the default version verifies on both amd64 and arm64 with nothing supplied. `target_checksum` is the
escape hatch for a version the role does not pin — and if you select such a version without it, the
build stops with a named error rather than downloading unverified:

```
No SHA256 is pinned for go1.25.0.linux-amd64.tar.gz on amd64. Pass target_checksum
to install a version or architecture that is not in the role's pinned map.
```

Option defaults live in each feature's `devcontainer-feature.json` and nowhere else — the Ansible
roles carry no defaults of their own. See
[ADR-012](/trusted-devcontainer-features/decisions/adr-012-feature-role-contract/).

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

## Using a trusted base image

These features target the trusted Fedora 43 and UBI base images. They require the `bootstrap` feature, which every feature declares under `dependsOn`, so it is installed automatically. Use a Containerfile that sets up a non-root `dev` user:

```dockerfile
FROM ghcr.io/infrashift/trusted-base-images/trusted/fedora43-minimal:latest

# fedora43-minimal is genuinely minimal. Features need these:
#   tar/gzip  archive extraction
#   curl      downloads
#   util-linux  setpriv, used to drop to the target user
RUN dnf5 -y install --allowerasing --setopt=install_weak_deps=False \
        tar gzip curl util-linux unzip libicu openssl-libs \
    && dnf5 clean all && rm -rf /var/cache/dnf

RUN groupadd --gid 1001 dev \
    && useradd -m -s /bin/bash --uid 1001 --gid 1001 dev

USER dev
ENV PATH="/home/dev/.local/bin:${PATH}"
```

You no longer install `uv` yourself. The `bootstrap` feature installs a pinned,
checksum-verified `uv` and builds the Ansible environment the other features run
from — see [ADR-008](/trusted-devcontainer-features/decisions/adr-008-pinned-bootstrap-environment/).

## Local testing

Features are tested by building the templates under `test-templates/` and
exercising them, which is what CI does — there is no per-feature test tree.

```bash
# Verify every role satisfies the parameter contract (seconds, no containers)
make check-contract

# Build one template and run its smoke tests
make test-template TEMPLATE=python

# Idempotency and failure-mode tests against that running container
make test-contract TEMPLATE=python

# Everything: contract check, then all six templates
make test
```

## Next steps

- Browse the [Feature Inventory](/trusted-devcontainer-features/features/) for the full list of available features
- Read about [AI-Powered DevContainers](/trusted-devcontainer-features/ai-support/) for Claude Code and OpenAI Codex setup
- Check the [Architecture](/trusted-devcontainer-features/reference/architecture/) for how features work under the hood
