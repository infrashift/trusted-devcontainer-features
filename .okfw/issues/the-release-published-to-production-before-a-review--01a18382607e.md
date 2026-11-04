---
id: "01a18382-607e-754e-835b-02b18960bd69"
title: "The release published to production before a review"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "resolved"
  - "release"
  - "signing-actors"
created: "2026-10-28T12:15:22-05:00"
timestamp: "2026-10-28T12:20:56-05:00"
description: "One release job published to production and then checked its own output; PR #13 adds stage, review and promote by digest."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:56-05:00"
status: "deprecated"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/13"
    title: "PR #13"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/commit/f444103"
    title: "Commit f444103"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/.github/workflows/release.yaml"
---

# The release published to production before a review

The release job published each feature to the production namespace and then checked what it had published. A defect reached consumers before the check failed.

## Problem

One job held the signing key, published the features, and also attested that its own publish was correct. The check in `verify-published-refs.sh` was detective, not preventive. This also broke the separation that the three signing actors exist to give.

## Context

* The Build-Actor, the Review-Actor and the Release-Actor are the three signing actors.
* A tag can move between a review and a promotion. Only a digest list makes the reviewed bytes and the shipped bytes the same.

## Acceptance criteria

- [x] The Build-Actor publishes only to a staging namespace.
- [x] The Review-Actor reads the staged features by digest and signs a verdict.
- [x] The Release-Actor promotes only the digests that the verdict names.

## Resolution

* Date: 2026-09-10. PR #13 (merge `e7f04c1`). Commit `f444103` added `.github/pdp/public-keys/review.pub`.
* `scripts/review-staged-features.sh` checks the staged features and writes the verdict. It rejects relative references, an unpinned `dependsOn` and a `dependsOn` outside the production namespace.
* `scripts/promote-features.sh` verifies the verdict signature, refuses if staging moved after the review, and asserts the landed digest.
* PR #13 tested `promote-features.sh` with cosign v2.6.1 and a stub `crane`. The first real release was the first end-to-end test.

## Related

* [Release workflow](/supply-chain/release-workflow--01a1837fdeee.md)
* [Stage, review and promote by digest](/supply-chain/stage-review-and-promote-by-digest--01a1837fdf62.md)
* [Promotion moved old version tags onto the newest build](/issues/promotion-moved-old-version-tags-onto-the-newest-build--01a1838260cd.md)
* [Promotion copied features to production before it signed them](/issues/promotion-copied-features-to-production-before-it-signed-them--01a1838260f4.md)
* [The docs site does not describe the release pipeline or signature checks](/issues/the-docs-site-does-not-describe-the-release-pipeline-or-signature-checks--01a1838265c1.md)
* [Supply-chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
