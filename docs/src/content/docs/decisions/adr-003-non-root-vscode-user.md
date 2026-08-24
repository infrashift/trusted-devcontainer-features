---
title: "ADR-003: Non-Root vscode User Convention"
description: Decision to standardize on a non-root vscode user for DevContainers.
---

**Status:** Superseded by [ADR-011](/trusted-devcontainer-features/decisions/adr-011-dev-user-alignment/)

## Context

Dev Container Features run `install.sh` as root, but the development experience should run as a non-root user for security. The Dev Container ecosystem uses a `remoteUser` setting to control this. We needed a convention for the default user identity that features install software for.

## Decision

Standardize on a `vscode` user with UID/GID 1000:1000. The base Containerfile creates this user, and features install user-scoped software into `/home/vscode/.local/bin`, `/home/vscode/.local/share/`, and related paths. Install scripts run as root but configure software ownership for the `vscode` user.

## Consequences

- **Positive**: Consistent user identity across all features simplifies path configuration and file ownership.
- **Positive**: Non-root operation follows security best practices — the development shell doesn't run as root.
- **Positive**: UID 1000 aligns with the most common non-root user ID, reducing permission issues with bind mounts.
- **Negative**: Features assume `/home/vscode` exists. Custom usernames require overriding the `DEVCONTAINER_USERNAME` environment variable.
- **Negative**: User-scoped installations mean tools are not available to other users in the container.

## Alternatives Considered

- **Root user**: Rejected. Running development sessions as root is a security anti-pattern.
- **Dynamic user detection**: Rejected. Adds complexity to every feature for a marginal use case. The Containerfile supports overriding the username via build args.
- **System-wide installation to /usr/local**: Rejected. Would require root for tool execution and conflicts with other feature installations.
