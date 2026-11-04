---
id: "01a18382-64d9-774c-93c5-9f34e980cde1"
title: "The main ruleset does not require test/gate"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "open"
  - "github-settings"
  - "ci"
created: "2026-10-28T12:15:23-05:00"
timestamp: "2026-10-28T12:20:47-05:00"
description: "test-templates.yaml is path-filtered, so a required test/gate would block docs-only PRs; main requires only repo-gate until pr-gate seeds test/gate."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:47-05:00"
status: "draft"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/SETUP-ENVIRONMENTS.md"
    title: "SETUP-ENVIRONMENTS.md"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/.github/workflows/test-templates.yaml"
---

# The main ruleset does not require test/gate

The ruleset on `main` requires only the `repo-gate` check. The `test/gate` check from `test-templates.yaml` is not required.

## Problem

A PR can merge while the test templates fail. `test-templates.yaml` runs only for changes under `src/`, `test-templates/`, `scripts/`, `tools.lock` or its own file. On a PR that changes none of these, `test/gate` never reports. A required `test/gate` would then block the PR forever.

## Context

* Verified on 2026-10-28: ruleset `main` (id 21314109) has `required_status_checks: [{"context": "repo-gate"}]`.
* `SETUP-ENVIRONMENTS.md` section 5 gives the reason and the fix: `pr-gate.yml` must publish a `success` status for `test/gate` when a PR changes no test path.
* The templates repository had the same problem with `build/gate`, and fixed it with a status from its unfiltered `pr-gate.yml`.

## Acceptance criteria

- [ ] `pr-gate.yml` sets `test/gate` to `success` on a PR that changes no test path.
- [ ] The ruleset requires `test/gate`.
- [ ] A docs-only PR shows `test/gate` as passed and is not blocked.

## Related

* [PR Gate workflow](/supply-chain/pr-gate-workflow--01a1837fdeb7.md)
* [Set up the GitHub environments and signing keys](/operations/set-up-the-github-environments-and-signing-keys--01a1837fe20a.md)
* [The main branch had no protection](/issues/the-main-branch-had-no-protection--01a183826317.md)
* [CODEOWNERS and the human gate assume a multi-person org](/issues/codeowners-and-the-human-gate-assume-a-multi-person-org--01a183826510.md)
* [Supply-chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
* [Operations overview](/operations/operations-overview--01a1837af719.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
