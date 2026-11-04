---
id: "01a18382-65c1-70ba-96f2-a81cfe54b79d"
title: "The docs site does not describe the release pipeline or signature checks"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "open"
  - "docs"
  - "signing"
created: "2026-10-28T12:15:23-05:00"
timestamp: "2026-10-28T12:20:47-05:00"
description: "No docs page describes stage, review and promote, or tells a consumer how to verify a feature signature with release.pub."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:47-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/sign-features.sh"
---

# The docs site does not describe the release pipeline or signature checks

The release stages, reviews, signs and promotes each feature by digest. No page in `docs/src/content/docs/` describes this, and no page tells a consumer how to verify a signature.

## Problem

A consumer cannot learn from the docs site that the features are signed, or which key to use. A search of the docs site for `Review-Actor`, `promote`, `staging` and `cosign verify` finds only the roadmap item about cosign.

## Context

* `scripts/sign-features.sh` signs each feature with the release key and again keyless, with a Rekor entry.
* The public keys are `.github/pdp/public-keys/release.pub` and `.github/pdp/public-keys/review.pub`.
* `SETUP-ENVIRONMENTS.md` describes the actors for the maintainer, not for a consumer.

## Acceptance criteria

- [ ] A docs page describes stage, review and promote, and the role of each signing actor.
- [ ] A docs page gives the `cosign verify` command for a feature digest, with `release.pub`.

## Related

* [The release published to production before a review](/issues/the-release-published-to-production-before-a-review--01a18382607e.md)
* [The architecture page disagrees with the code](/issues/the-architecture-page-disagrees-with-the-code--01a183826585.md)
* [Bring the docs site in line with the code](/plans/bring-the-docs-site-in-line-with-the-code--01a1838268e3.md)
* [Supply-chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
