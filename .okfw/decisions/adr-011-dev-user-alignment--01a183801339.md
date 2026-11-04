---
id: "01a18380-1339-768b-984e-965411de41f3"
title: "ADR-011: dev user alignment"
type: "decision"
tags:
  - "decision"
  - "adr-011"
  - "dev-user"
created: "2026-10-28T12:12:51-05:00"
timestamp: "2026-10-28T12:17:22-05:00"
description: "Accepted: the dev user is dev with UID 1001, and the runner takes the user and home from the devcontainer CLI. Supersedes ADR-003."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:22-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/decisions/adr-011-dev-user-alignment.md"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/bootstrap/assets/run-feature.sh"
    title: "The runner run-feature.sh"
---

# ADR-011: dev user alignment

ADR-011 makes the dev user `dev` with UID and GID 1001, the same as the templates repository. More important, no feature hard-codes the user. The runner takes the user and the home from `_REMOTE_USER` and `_REMOTE_USER_HOME`, which the devcontainer CLI sets.

**Status:** Accepted. Supersedes [ADR-003: Non-root vscode user](/decisions/adr-003-non-root-vscode-user--01a1838011d7.md).

## Decision

`run-feature.sh` passes `_REMOTE_USER` and `_REMOTE_USER_HOME` to the role as `_target_username` and `_target_user_home`. It stops with an error if either is empty, because a wrong default installs tools into a home that nobody uses. `containerEnv` values are static, so they can still hold the literal `/home/dev`.

## Code check on 2026-10-28

The code agrees. `run-feature.sh` has the check. `test-templates/shared/Containerfile` makes `dev` with UID 1001. `containerEnv` holds the literal `/home/dev` in `dotnet`, `golang`, `openjdk` and `pnpm`, which the ADR allows. The ADR mentions an `egress-filter` feature, which does not exist in `src/` now.

## Features affected

All features that install for the dev user. Literal paths in `containerEnv`: [Feature: dotnet](/features/feature-dotnet--01a183800dda.md), [Feature: golang](/features/feature-golang--01a183800e75.md), [Feature: openjdk](/features/feature-openjdk--01a18380102a.md), [Feature: pnpm](/features/feature-pnpm--01a183801056.md).

## Related

* [ADR-003: Non-root vscode user](/decisions/adr-003-non-root-vscode-user--01a1838011d7.md) — the superseded convention.
* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md) — the runner that injects the user.
* [Decisions overview](/decisions/decisions-overview--01a1837af6ce.md)
