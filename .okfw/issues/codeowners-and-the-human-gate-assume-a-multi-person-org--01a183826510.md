---
id: "01a18382-6510-7a49-aa70-edb6f0a263ab"
title: "CODEOWNERS and the human gate assume a multi-person org"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "open"
  - "github-settings"
  - "governance"
created: "2026-10-28T12:15:23-05:00"
timestamp: "2026-10-28T12:20:47-05:00"
description: "The org has one member and no teams, so approvals stay at 0 and code owner review stays off until a second maintainer joins."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:47-05:00"
status: "draft"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/.github/CODEOWNERS"
    title: ".github/CODEOWNERS"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/SETUP-ENVIRONMENTS.md"
---

# CODEOWNERS and the human gate assume a multi-person org

The org `infrashift` has one member and no teams. GitHub does not let a user approve the user's own PR, so the ruleset cannot require an approval or a code owner review.

## Problem

The three-actor model separates keys, but one person holds all of them. No second human reviews a change before it merges. `.github/CODEOWNERS` lists `@ryancraig` and says at the top that it assigns reviewers and gates nothing.

## Context

* Verified on 2026-10-28: `gh api orgs/infrashift/teams --jq length` returns 0, and the org has 1 member.
* Verified on 2026-10-28: ruleset `main` has `required_approving_review_count: 0`, `require_code_owner_review: false` and no bypass actors.
* `require_extra_approval_for_unattributed_changes` is `true`. It has no effect at 0 approvals, but it becomes live when the count goes up.
* `SETUP-ENVIRONMENTS.md` section 4 ("Teams — not yet, and not silently") gives the steps for a second maintainer.

## Acceptance criteria

- [ ] When a second maintainer joins, create the teams in `SETUP-ENVIRONMENTS.md` section 4.
- [ ] In the same change, update `.github/CODEOWNERS`, turn on code owner review, set approvals to 1 and set *Prevent self-review* on `Release-Actor`.
- [ ] Keep `bypass_actors` empty.

## Related

* [Signing actors and keys](/supply-chain/signing-actors-and-keys--01a1837fdf43.md)
* [CODEOWNERS](/supply-chain/codeowners--01a1837fe0ed.md)
* [Set up the GitHub environments and signing keys](/operations/set-up-the-github-environments-and-signing-keys--01a1837fe20a.md)
* [The main branch had no protection](/issues/the-main-branch-had-no-protection--01a183826317.md)
* [The main ruleset does not require test/gate](/issues/the-main-ruleset-does-not-require-test-gate--01a1838264d9.md)
* [Supply-chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
* [Operations overview](/operations/operations-overview--01a1837af719.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
