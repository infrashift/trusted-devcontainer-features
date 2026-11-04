---
id: "01a18382-6378-789d-95d3-7135615bee5f"
title: "The pipeline published unsigned features with movable action tags"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "resolved"
  - "signing"
  - "ci"
created: "2026-10-28T12:15:22-05:00"
timestamp: "2026-10-28T12:20:56-05:00"
description: "Before PR #1 the release signed nothing, five actions used movable tags and release.yaml granted write access to every job."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:56-05:00"
status: "deprecated"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/1"
    title: "PR #1"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/commit/429d5e8"
    title: "Commit 429d5e8"
---

# The pipeline published unsigned features with movable action tags

Before 2026-08-24 the release pushed features to GHCR and signed nothing. A consumer could not tell a feature from this org from a feature in a lookalike repository.

## Problem

* The release signed no feature.
* Five actions used movable tags, for example `actions/checkout@v4` and `devcontainers/action@v1`. `devcontainers/action` runs in the job that holds a signing key.
* `release.yaml` granted `contents: write` and `packages: write` at the workflow level, so read-only jobs also had them.

## Context

* The work aligned this repository with the hardened reference pipeline of the org (commit `429d5e8`).
* `tools.lock` and `scripts/install-tools.sh` came from the templates repository.

## Acceptance criteria

- [x] The release signs each published feature by digest.
- [x] Each action is pinned to a full commit SHA.
- [x] Each workflow has `permissions: {}` and grants permissions per job.

## Resolution

* Date: 2026-08-24. PR #1 (merge `476e216`).
* `scripts/sign-features.sh` signs each feature twice: with the release key, and keyless for a Rekor entry.
* The release runs in the `Release-Actor` environment, which only `main` can deploy to. Commit `fa04742` added `.github/pdp/public-keys/release.pub`.
* PR #1 also added the PDP in `.github/pdp` and the repo gate.

## Related

* [Signing actors and keys](/supply-chain/signing-actors-and-keys--01a1837fdf43.md)
* [Promotion copied features to production before it signed them](/issues/promotion-copied-features-to-production-before-it-signed-them--01a1838260f4.md)
* [The release published to production before a review](/issues/the-release-published-to-production-before-a-review--01a18382607e.md)
* [Supply-chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
