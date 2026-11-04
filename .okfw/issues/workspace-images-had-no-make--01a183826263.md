---
id: "01a18382-6263-77f2-8cdf-e8ebcfdce324"
title: "Workspace images had no make"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "resolved"
  - "make"
created: "2026-10-28T12:15:22-05:00"
timestamp: "2026-10-28T12:20:56-05:00"
description: "The seed documents tell developers to run make all, but the base images have no make; PR #17 adds the make feature."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:56-05:00"
status: "deprecated"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/17"
    title: "PR #17"
---

# Workspace images had no make

Every seed repository has a `Makefile`, and the seed documents tell developers to run `make all`. The trusted base images have no `make`, so the command failed in a workspace.

## Problem

A developer who obeyed the seed README, `RDW-DEV-GUIDE-*.md` or `DEVELOPER-SEED-TO-WORKSPACE.md` got `make: command not found`.

## Context

* The maintainer found the gap on 2026-09-16 in a walk-through of the .NET tutorial on a real workspace.
* The platform pipeline runs `make build test` in the runner image, which has `make`. It never runs `make` in the workspace image.

## Acceptance criteria

- [x] A feature installs GNU Make.
- [x] The `dotnet-node` template, its `tests.sh` and `ROLE_ARGS` in `contract-tests.sh` cover it.

## Resolution

* Date: 2026-09-16. PR #17 (merge `90ca3c7`).
* The `make` feature installs the distribution RPM in the privileged lane. It has no options.

## Related

* [Feature: make](/features/feature-make--01a183800f4f.md)
* [The architecture page disagrees with the code](/issues/the-architecture-page-disagrees-with-the-code--01a183826585.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
