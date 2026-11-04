---
id: "01a18382-63ac-7ee8-b76c-1d32d17aa4fd"
title: "The maintainer dev container could not be built"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "resolved"
  - "maintainer-devcontainer"
created: "2026-10-28T12:15:22-05:00"
timestamp: "2026-10-28T12:20:56-05:00"
description: "The maintainer dev container named a missing vscode user and referenced features as ../src/<id>; commits 4aa3e85 and 9f84a31 fix both."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:56-05:00"
status: "deprecated"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/1"
    title: "PR #1"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/commit/4aa3e85"
    title: "Commit 4aa3e85"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/commit/9f84a31"
    title: "Commit 9f84a31"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/.devcontainer/devcontainer.json"
---

# The maintainer dev container could not be built

The maintainer dev container in `.devcontainer/` had two defects. It had never started.

## Problem

* `devcontainer.json` set `containerUser` to `vscode`, but the `Containerfile` creates only `dev` 1001.
* `devcontainer.json` referenced features as `"../src/<id>"`. The CLI rejects this, because a local feature path must be a child of `.devcontainer/`.
* The build context was `..`, so each build sent about 250MB to the daemon.

## Context

* These were TODO 14 and TODO 16 in the old `TODO.md`.
* The maintainer dev container must use the working tree, not the published features.

## Acceptance criteria

- [x] The dev container uses the `dev` user.
- [x] The features resolve from the working tree.
- [x] The dev container builds and runs all features.

## Resolution

* Date: 2026-08-24. PR #1, commits `4aa3e85` and `9f84a31`.
* `scripts/prepare-devcontainer.sh` copies `src/*` into `.devcontainer/`. `initializeCommand` runs it on the host before the CLI resolves features.
* Feature paths became `"./<id>"`, and `./bootstrap` joined the list. The build context became `.`.
* The dev container built as `uid=1001(dev)` with 18 plays and no failures.

## Related

* [Use the maintainer dev container](/operations/use-the-maintainer-dev-container--01a1837fe25c.md)
* [The make test targets called a test tree that did not exist](/issues/the-make-test-targets-called-a-test-tree-that-did-not-exist--01a1838263e4.md)
* [Architecture overview](/architecture/architecture-overview--01a1837af69f.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
