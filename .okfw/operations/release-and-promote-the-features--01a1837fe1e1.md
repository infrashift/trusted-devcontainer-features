---
id: "01a1837f-e1e1-7dbb-9e97-fbe73ed46829"
title: "Release and promote the features"
type: "runbook"
tags:
  - "runbook"
  - "release"
created: "2026-10-28T12:12:38-05:00"
timestamp: "2026-10-28T12:20:27-05:00"
description: "A merge to main starts release.yaml; approve the two Release-Actor gates after you read each review log, then read the summary."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:27-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/.github/workflows/release.yaml"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/promote-features.sh"
    title: "scripts/promote-features.sh"
---

# Release and promote the features

A merge to `main` starts the [Release workflow](/supply-chain/release-workflow--01a1837fdeee.md). No manual tag or command starts a release. A human approves the two `Release-Actor` jobs. `Build-Actor` and `Review-Actor` have no required reviewers, so their jobs start without approval.

## Prerequisites

* The pull request has a new `version` for each changed feature, and `repo-gate` passed.
* You are a required reviewer of `Release-Actor`.

## Procedure

1. Merge the pull request to `main`.
2. Open the `Release Dev Container Features` run in the Actions tab, or run `gh run list --workflow release.yaml --limit 1`.
3. Wait for `role contract`, `Stage bootstrap` and `Review staged bootstrap`.
4. Read the log of `Review staged bootstrap`. Make sure that it shows `ok bootstrap @ sha256:...` and `OK: 1 staged feature(s) reviewed`.
5. Approve the `Release-Actor` deployment of `Promote bootstrap`.
6. Wait for `Stage dependents` and `Review staged dependents`.
7. Read the log of `Review staged dependents`. Make sure that it shows `expecting dependsOn == ghcr.io/.../bootstrap@sha256:...` and an `ok` line for each feature.
8. Approve the `Release-Actor` deployment of `Promote dependents`.
9. Read the `Release Summary`. All seven rows must show `success`.
10. Verify one changed feature. See [Verify a published feature](/operations/verify-a-published-feature--01a1837fe2c1.md).

To approve from the command line, use the GitHub API endpoint `POST /repos/infrashift/trusted-devcontainer-features/actions/runs/<run-id>/pending_deployments` with the `Release-Actor` environment id and `state=approved`.

## What a promote job reports

* `verdict signature verified against .github/pdp/public-keys/review.pub`
* For each feature: `promoted <id> @ <digest> (<n> tag(s), <m> signature tag(s))`
* For an unchanged feature, the seed step copied the production bytes, so the promotion copies the same digest again.

## If a job fails

* The release does not cancel a run in progress. A queued run waits.
* `promote-features.sh` refuses a digest when staging moved after the review. Run the workflow again from the start, not only the promote job.
* `check-published-drift.sh --seed` fails when the source differs from production at the same version. Bump the version in a new pull request.

## Related

* [Stage, review and promote by digest](/supply-chain/stage-review-and-promote-by-digest--01a1837fdf62.md)
* [Signing actors and keys](/supply-chain/signing-actors-and-keys--01a1837fdf43.md)
* [Change a feature and bump its version](/operations/change-a-feature-and-bump-its-version--01a1837fe143.md)
* [Operations overview](/operations/operations-overview--01a1837af719.md)
