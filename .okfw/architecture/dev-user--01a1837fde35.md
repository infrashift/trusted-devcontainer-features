---
id: "01a1837f-de35-73d2-be96-17015dd768cf"
title: "Dev user"
type: "component"
tags:
  - "architecture"
  - "dev-user"
created: "2026-10-28T12:12:37-05:00"
timestamp: "2026-10-28T12:20:26-05:00"
description: "Features never hardcode the user: the runner reads _REMOTE_USER and _REMOTE_USER_HOME, and the test Containerfile defaults to dev 1001:1001."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:26-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/test-templates/shared/Containerfile"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/decisions/adr-011-dev-user-alignment.md"
    title: "ADR-011"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/test-templates/dotnet-node/.devcontainer/devcontainer.json"
    title: "dotnet-node test template"
---

# Dev user

A feature does not hardcode the user. The runner reads `_REMOTE_USER` and `_REMOTE_USER_HOME` from the devcontainer CLI and passes them to the role as `_target_username` and `_target_user_home` (ADR-011). When one of them is not set, the runner stops with an error. It does not guess.

## The default account

`test-templates/shared/Containerfile` creates the account from three build arguments:

| Argument | Default |
|---|---|
| `USERNAME` | `dev` |
| `USER_UID` | `1001` |
| `USER_GID` | `1001` |

The test templates set `containerUser` and `updateRemoteUserUID: false`. Each template runs as `dev`, except `dotnet-node`.

## The `dotnet-node` template

`dotnet-node` builds the account `user`, UID 1001, GID 0. The trusted seeds of the platform use this account. The template tests that a feature works when the home directory is not `/home/dev`. `sqlpackage` 1.0.0 failed in a real workspace for this reason, but passed in the old tests.

## Two rules for the account

* The Containerfile makes a group with the name of the user also when the GID is 0. `setpriv --regid=<user>` finds the group by the user name.
* `contract-tests.sh` reads `containerUser` from the template. It does not use a constant `dev`.

## Known limit

Four `containerEnv` values hold the literal `/home/dev`: `DOTNET_ROOT`, `JAVA_HOME`, `GOPATH` and `PNPM_HOME`. Under a different user name they point to a directory that does not exist. See [Install paths](/architecture/install-paths--01a1837fde1b.md).

## Related

* [ADR-003: Non-root vscode user](/decisions/adr-003-non-root-vscode-user--01a1838011d7.md)
* [ADR-011: Dev user alignment](/decisions/adr-011-dev-user-alignment--01a183801339.md)
* [Install paths](/architecture/install-paths--01a1837fde1b.md)
* [Userland and privileged lanes](/architecture/userland-and-privileged-lanes--01a1837fddb9.md)
* [Test templates](/architecture/test-templates--01a1837fde68.md)
* [Decisions overview](/decisions/decisions-overview--01a1837af6ce.md) — ADR-003 and ADR-011.
* [Architecture overview](/architecture/architecture-overview--01a1837af69f.md)
