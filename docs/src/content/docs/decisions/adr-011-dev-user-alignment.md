---
title: "ADR-011: Non-Root dev User Alignment"
description: Decision to standardize on the dev user (UID 1001) and derive all paths from the devcontainer CLI.
---

**Status:** Accepted — supersedes [ADR-003](/trusted-devcontainer-features/decisions/adr-003-non-root-vscode-user/)

## Context

[ADR-003](/trusted-devcontainer-features/decisions/adr-003-non-root-vscode-user/) standardized on `vscode` with UID/GID 1000. The trusted templates repository independently standardized on `dev` with UID/GID 1001, for reasons recorded in its own ADR-003: `dev` is editor-neutral, and 1001 avoids colliding with the host's usual UID 1000.

The two repositories disagreed, and the features had drifted into an inconsistent middle state:

- Three features hardcoded `/home/dev` in `containerEnv.PATH` (`cuelang`, `uv-ruff`, `claude-code`) while ADR-003 said the user was `vscode`.
- `dotnet` and `egress-filter` carried a defensive fallback pairing the **`vscode` user** with the **`/home/dev` home directory** — a combination that is wrong under either convention.
- The repository `Makefile` built its test base as `vscode`/1000 while CI and the test templates used `dev`/1001.

The fallbacks existed because `_REMOTE_USER` was believed unreliable. It is not: the devcontainer specification requires the CLI to set `_REMOTE_USER` and `_REMOTE_USER_HOME` for every feature install.

## Decision

Standardize on **`dev`, UID/GID 1001**, matching the templates repository.

More importantly, stop hardcoding it. Identity and paths are taken from `_REMOTE_USER` and `_REMOTE_USER_HOME`, which `run-feature.sh` injects as `_target_username` and `_target_user_home`. The runner **fails loudly** if either is unset rather than guessing:

```bash
if [ -z "${TARGET_USER}" ] || [ -z "${TARGET_HOME}" ]; then
    echo "ERROR: _REMOTE_USER / _REMOTE_USER_HOME are not set." >&2
    exit 1
fi
```

A wrong-but-plausible default is worse than a clear failure: it installs tools into a home directory nobody uses, and the container appears to build successfully.

## Consequences

- **Positive**: One user identity across both repositories.
- **Positive**: Features work with any `remoteUser`, because nothing is hardcoded.
- **Positive**: The `vscode` + `/home/dev` fallback bug is removed rather than corrected.
- **Positive**: Misconfiguration surfaces immediately with an actionable message.
- **Negative**: Any consumer relying on `vscode`/1000 must change their base image or set `remoteUser`.
- **Negative**: `containerEnv.PATH` entries still need a literal path, since they are static metadata evaluated before the user is known. These remain the one place the convention is written down.

## Alternatives Considered

- **Standardize on `vscode`/1000**: Would require changing the templates repository, its ADR-003, and every published template, to land on a UID that more often collides with the host user.
- **Keep both and branch**: Doubles the test matrix to support a difference with no technical justification.
- **Keep the fallbacks, fix the inconsistency**: Preserves silent-wrong-install behaviour; the spec guarantees the variables, so a fallback has no legitimate trigger.
