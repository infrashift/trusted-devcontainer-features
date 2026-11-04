---
id: "01a18382-60f4-7428-8bb7-1bc4928051ed"
title: "Promotion copied features to production before it signed them"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "resolved"
  - "release"
  - "signing"
  - "sqlpackage"
created: "2026-10-28T12:15:22-05:00"
timestamp: "2026-10-28T12:20:56-05:00"
description: "A signing failure after promotion left sqlpackage 1.0.2 unsigned in production; PR #20 signs staging first and promotion refuses an unsigned digest."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:56-05:00"
status: "deprecated"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/20"
    title: "PR #20"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/sign-features.sh"
---

# Promotion copied features to production before it signed them

The release promoted the features first and signed them second. On 2026-09-16 a signing failure left `sqlpackage` 1.0.2 in production with no signature.

## Problem

A cosign keyless step failed on a GitHub OIDC error after the promotion had copied every tag. Production then held an unsigned feature, and nothing downstream noticed.

## Context

* cosign stores a signature as its own manifest under a tag that it derives from the digest. A copy of every tag from the image would overwrite that signature tag with the image.
* This path runs only on a push to `main`. Local checks cannot run it.

## Acceptance criteria

- [x] The release signs the staged digest before it promotes.
- [x] Promotion refuses a digest that has no signature.
- [x] Promotion copies the signature tags tag to tag.

## Resolution

* Date: 2026-09-16. PR #20 (merge `5c58bb3`), part 3.
* `scripts/sign-features.sh` signs in the namespace that `SIGN_NAMESPACE` names. The release sets it to staging.
* `scripts/promote-features.sh` refuses a digest that it cannot find a signature for. If signing fails, promotion fails closed.

## Related

* [Release workflow](/supply-chain/release-workflow--01a1837fdeee.md)
* [Stage, review and promote by digest](/supply-chain/stage-review-and-promote-by-digest--01a1837fdf62.md)
* [The release published to production before a review](/issues/the-release-published-to-production-before-a-review--01a18382607e.md)
* [The pipeline published unsigned features with movable action tags](/issues/the-pipeline-published-unsigned-features-with-movable-action-tags--01a183826378.md)
* [The sqlpackage feature could not find the .NET runtime](/issues/the-sqlpackage-feature-could-not-find-the-net-runtime--01a183826142.md)
* [Supply-chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
