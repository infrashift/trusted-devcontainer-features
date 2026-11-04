---
id: "01a18382-6142-73c8-8660-e85fda268813"
title: "The sqlpackage feature could not find the .NET runtime"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "resolved"
  - "sqlpackage"
  - "dotnet"
created: "2026-10-28T12:15:22-05:00"
timestamp: "2026-10-28T12:20:56-05:00"
description: "sqlpackage 1.0.0 and 1.0.1 exited 131 because the apphost could not find .NET; PRs #18 and #19 ship a wrapper that sets DOTNET_ROOT."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:56-05:00"
status: "deprecated"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/18"
    title: "PR #18"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/19"
    title: "PR #19"
---

# The sqlpackage feature could not find the .NET runtime

`sqlpackage` 1.0.0 and 1.0.1 installed correctly but could not run. The apphost exited 131 with `.NET location: Not found`.

## Problem

SqlPackage is a .NET apphost. It finds its runtime through `DOTNET_ROOT`. The `dotnet` feature installs the SDK in `~/.local/share/dotnet`, where an apphost does not look.

* 1.0.0 put a symlink on `PATH`. The verify task did not set `DOTNET_ROOT`, so it failed.
* 1.0.1 used a wrapper with `DOTNET_ROOT="${DOTNET_ROOT:-…}"`. The `dotnet` feature sets `DOTNET_ROOT=/home/dev/.local/share/dotnet` in `containerEnv`, so the default never applied under another account.

## Context

* The platform pipeline (`devcontainer-seeds/dotnet-node` pipeline 19) found the failure on 2026-09-16.
* `App host version: 8.0.30` shows that the version pin was correct. Only the runtime lookup was wrong.

## Acceptance criteria

- [x] `sqlpackage /version` runs through the wrapper under any account.
- [x] The role verifies the tool through the wrapper.

## Resolution

* Date: 2026-09-16. PR #18 (merge `8ccb2ba`) and PR #19 (merge `8ac698a`).
* The wrapper sets `DOTNET_ROOT` to the real SDK location that the role finds. It ignores an inherited value.
* `NOTES.md` of the feature records the reason.

## Related

* [Feature: sqlpackage](/features/feature-sqlpackage--01a1838010af.md)
* [The test templates used an account that no seed uses](/issues/the-test-templates-used-an-account-that-no-seed-uses--01a18382611a.md)
* [Four containerEnv values name /home/dev](/issues/four-containerenv-values-name-home-dev--01a183826729.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
