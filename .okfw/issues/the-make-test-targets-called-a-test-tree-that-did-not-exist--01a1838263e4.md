---
id: "01a18382-63e4-7961-a99c-a6735fe7e52f"
title: "The make test targets called a test tree that did not exist"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "resolved"
  - "testing"
created: "2026-10-28T12:15:22-05:00"
timestamp: "2026-10-28T12:20:56-05:00"
description: "make test and three other targets called devcontainers features test, which needs a removed test/ tree; commit 4aa3e85 replaced them."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:56-05:00"
status: "deprecated"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/1"
    title: "PR #1"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/commit/4aa3e85"
    title: "Commit 4aa3e85"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/Makefile"
---

# The make test targets called a test tree that did not exist

`make test`, `test-feature`, `test-scenarios` and `test-integration` called `devcontainers/cli features test`. That command needs a `test/` tree, which commit `f431c72` replaced with test templates.

## Problem

The four targets never ran. The README still showed them as the way to test.

## Context

* This was TODO 13 in the old `TODO.md`.
* The old `test-templates` target also had the same name as the `test-templates/` directory.

## Acceptance criteria

- [x] `make test` runs the checks and then every test template.
- [x] The README, `getting-started.md` and `contributing.md` show only targets that exist.

## Resolution

* Date: 2026-08-24. PR #1, commit `4aa3e85`.
* The commit removed the dead targets and `build-test-base`, and added `clean`.
* Today `make test` runs `make check`, then `test-template` and `test-contract` for each template in `TEMPLATES` (`Makefile` line 1).

## Related

* [Test templates](/architecture/test-templates--01a1837fde68.md)
* [The maintainer dev container could not be built](/issues/the-maintainer-dev-container-could-not-be-built--01a1838263ac.md)
* [The architecture page disagrees with the code](/issues/the-architecture-page-disagrees-with-the-code--01a183826585.md)
* [Operations overview](/operations/operations-overview--01a1837af719.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
