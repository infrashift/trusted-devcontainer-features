---
id: "01a18382-6056-7b44-8c18-1d022b9f8042"
title: "Feature dependsOn resolved bootstrap by tag, not by digest"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "resolved"
  - "pinning"
  - "bootstrap"
created: "2026-10-28T12:15:22-05:00"
timestamp: "2026-10-28T12:20:56-05:00"
description: "Each dependsOn named bootstrap with no digest, so a pinned feature pulled the current bootstrap; PRs #8 and #9 pin it by digest."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:56-05:00"
status: "deprecated"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/8"
    title: "PR #8"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/9"
    title: "PR #9"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/check-bootstrap-fanout.sh"
---

# Feature dependsOn resolved bootstrap by tag, not by digest

Each feature named `bootstrap` in `dependsOn` with no digest. A template that pinned a feature by digest still got the current `bootstrap:latest`.

## Problem

After [Published features had relative dependsOn references](/issues/published-features-had-relative-dependson-references--01a18382602b.md), the published `dependsOn` was an absolute registry reference without a digest. Thus the pin was only one level deep. A change to `bootstrap` reached every consumer at build time, with no review by the consumer.

## Context

* The dependency graph has two levels. Every feature depends on `bootstrap`, and `bootstrap` depends on nothing.
* `devcontainers/action` publishes a feature only when its `version` changes.
* `installsAfter` stays a bare reference. It is an order hint, not a fetch.

## Acceptance criteria

- [x] Every published `dependsOn` names `bootstrap` by digest.
- [x] A change to `bootstrap` also changes the version of each dependent.
- [x] The release fails if a published `dependsOn` has no digest.

## Resolution

* Date: 2026-08-24. PR #8 (merge `19947e3`) and PR #9 (merge `94e5585`).
* PR #8 publishes in two phases. The release publishes `bootstrap`, reads its digest with `crane`, rewrites the other features, and then publishes them.
* PR #8 adds `scripts/check-bootstrap-fanout.sh` (`make check-fanout`). It enforces the fan-out rule.
* The first release after PR #8 failed in `verify-published-refs.sh`, because no dependent version changed. PR #9 bumped the 19 dependents so that they republished with the digest.

## Related

* [Bootstrap fan-out check](/supply-chain/bootstrap-fan-out-check--01a1837fdfa2.md)
* [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md)
* [Published features had relative dependsOn references](/issues/published-features-had-relative-dependson-references--01a18382602b.md)
* [An unchanged feature got a new digest on each staged release](/issues/an-unchanged-feature-got-a-new-digest-on-each-staged-release--01a1838260a7.md)
* [Architecture overview](/architecture/architecture-overview--01a1837af69f.md)
* [Supply-chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
