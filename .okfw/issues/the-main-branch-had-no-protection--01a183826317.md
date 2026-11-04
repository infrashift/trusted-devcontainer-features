---
id: "01a18382-6317-7ec3-8936-46c01c8f1c38"
title: "The main branch had no protection"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "resolved"
  - "github-settings"
created: "2026-10-28T12:15:22-05:00"
timestamp: "2026-10-28T12:20:56-05:00"
description: "Until PR #11 main had no ruleset, so direct pushes worked and repo-gate was advisory; a ruleset now requires a PR and repo-gate."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:56-05:00"
status: "deprecated"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/11"
    title: "PR #11"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/SETUP-ENVIRONMENTS.md"
    title: "SETUP-ENVIRONMENTS.md"
---

# The main branch had no protection

Until 2026-08-24, `rules/branches/main` returned an empty list. Direct pushes to `main` worked, no PR was necessary, and `repo-gate` was only advisory.

## Problem

Every template in the templates repository installs what this repository publishes. An unreviewed push to `main` starts a release. PR #11 calls this the gap with the widest effect.

## Context

* An approval count of 1 with an admin bypass blocked every PR on 2026-08-24, because a user cannot approve the user's own PR. The maintainer set the count back to 0 on the same day.
* `bypass_mode: always` applies to the full ruleset. The maintainer removed the bypass actor, so no admin can merge past `repo-gate`.

## Acceptance criteria

- [x] A ruleset on `main` requires a PR and the `repo-gate` check.
- [x] The ruleset blocks deletion and non-fast-forward pushes.
- [x] `SETUP-ENVIRONMENTS.md` records the applied state.

## Resolution

* Date: 2026-08-24. PR #11 (merge `eb9854b`).
* Verified on 2026-10-28: ruleset `main` (id 21314109) is active, requires `repo-gate`, has 0 approvals and no bypass actors.
* `test/gate` is not required. See [The main ruleset does not require test/gate](/issues/the-main-ruleset-does-not-require-test-gate--01a1838264d9.md).

## Related

* [The main ruleset does not require test/gate](/issues/the-main-ruleset-does-not-require-test-gate--01a1838264d9.md)
* [CODEOWNERS and the human gate assume a multi-person org](/issues/codeowners-and-the-human-gate-assume-a-multi-person-org--01a183826510.md)
* [Operations overview](/operations/operations-overview--01a1837af719.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
