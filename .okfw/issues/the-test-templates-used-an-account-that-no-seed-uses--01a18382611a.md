---
id: "01a18382-611a-7229-a3f7-db41f8b1b573"
title: "The test templates used an account that no seed uses"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "resolved"
  - "testing"
  - "dev-user"
created: "2026-10-28T12:15:22-05:00"
timestamp: "2026-10-28T12:20:56-05:00"
description: "Templates ran as dev 1001:1001 but seeds run as user 1001:0, so account-dependent features passed CI; PR #20 tests the seed account."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:56-05:00"
status: "deprecated"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/20"
    title: "PR #20"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/test-templates/shared/Containerfile"
---

# The test templates used an account that no seed uses

The test templates ran as `dev` 1001:1001, but every trusted seed runs as `user` 1001:0. A feature that needed the account to be `dev` passed CI and failed in a workspace.

## Problem

Fifteen features wrote a literal `/home/dev` path into `containerEnv`. Under the `dev` account these paths were correct, so CI could not find a feature that depended on them. `sqlpackage` 1.0.0 passed CI and could not run in a workspace.

## Context

* The platform host volume belongs to 1001:0, and its jobspec expects that account.
* `${containerEnv:HOME}` does not work. The CLI writes `containerEnv` into a Dockerfile `ENV`, which rejects the `:H` modifier.

## Acceptance criteria

- [x] One test template builds with the seed account.
- [x] Features put their binaries on `PATH` without a home path in `containerEnv`.

## Resolution

* Date: 2026-09-16. PR #20 (merge `5c58bb3`), parts 1 and 2.
* `dotnet-node` builds with `USERNAME=user` and `USER_GID=0` (`test-templates/dotnet-node/.devcontainer/devcontainer.json`).
* Six features (`dotnet`, `nodejs`, `golang`, `openjdk`, `claude-code`, `openai-codex`) link their binaries into `~/.local/bin`. Seven others only lost a redundant `PATH` entry.
* Four variables still name `/home/dev`. See [Four containerEnv values name /home/dev](/issues/four-containerenv-values-name-home-dev--01a183826729.md).

## Related

* [Test templates](/architecture/test-templates--01a1837fde68.md)
* [Four containerEnv values name /home/dev](/issues/four-containerenv-values-name-home-dev--01a183826729.md)
* [The sqlpackage feature could not find the .NET runtime](/issues/the-sqlpackage-feature-could-not-find-the-net-runtime--01a183826142.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
