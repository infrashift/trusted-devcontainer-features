---
id: "01a18389-4c99-72b3-ba84-f85d989b2d0e"
title: "Code comments give old counts and names"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "open"
  - "comments"
created: "2026-10-28T12:22:55-05:00"
timestamp: "2026-10-28T12:24:37-05:00"
description: "Comments in release.yaml, check-bootstrap-fanout.sh, lint-workflows.sh and two Containerfiles name 19 dependents, review.yml and runuser."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:24:37-05:00"
status: "draft"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/.github/workflows/release.yaml"
    title: "release.yaml"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/bootstrap/assets/run-feature.sh"
    title: "run-feature.sh"
---

# Code comments give old counts and names

Comments in five files state a count, a file or a tool that the code changed later. The code runs correctly, but a reader of the comment gets a wrong model.

## Problem

* `.github/workflows/release.yaml` lines 32, 45 and 311, and `scripts/check-bootstrap-fanout.sh` line 13, say that `bootstrap` has 19 dependents. There are 26. The error message at `release.yaml` line 131 also says "expected 19", but the check only tests for zero.
* `scripts/lint-workflows.sh` line 49 says that `review.yml` resolves a status context. This repository has no `review.yml`. The comment comes from `trusted-devcontainer-templates`.
* `test-templates/shared/Containerfile` and `.devcontainer/Containerfile` line 10 say that `util-linux` supplies `runuser` to drop to the target user. The runner uses `setpriv` (`src/bootstrap/assets/run-feature.sh` line 102).
* `scripts/check-role-contract.sh` line 20 and ADR-012 line 122 say that the base image has no `python3`, so a check must not use Python. Six other scripts call `python3`, for example `scripts/check-published-drift.sh` line 111.

## Context

The last item can be more than a comment error. If the maintainer dev container has no `python3`, `make check` can fail in it. Nobody has tested this.

## Acceptance criteria

- [ ] Each comment above states the current fact, or states a count in a form that does not go out of date ("every dependent").
- [ ] `make check` runs in the maintainer dev container, or the Python rule is removed from the comments.

## Related

* [Release workflow](/supply-chain/release-workflow--01a1837fdeee.md)
* [Bootstrap fan-out check](/supply-chain/bootstrap-fan-out-check--01a1837fdfa2.md)
* [Workflow lint](/supply-chain/workflow-lint--01a1837fe026.md)
* [Userland and privileged lanes](/architecture/userland-and-privileged-lanes--01a1837fddb9.md)
* [Use the maintainer dev container](/operations/use-the-maintainer-dev-container--01a1837fe25c.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
