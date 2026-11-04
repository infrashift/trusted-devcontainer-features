---
id: "01a18382-60a7-7b1f-a441-3fe6691ea13a"
title: "An unchanged feature got a new digest on each staged release"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "resolved"
  - "release"
  - "bootstrap"
created: "2026-10-28T12:15:22-05:00"
timestamp: "2026-10-28T12:20:56-05:00"
description: "Staging republished unchanged source into an empty namespace, so the bootstrap digest moved; PR #15 copies identical bytes from production instead."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:56-05:00"
status: "deprecated"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/15"
    title: "PR #15"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/check-published-drift.sh"
---

# An unchanged feature got a new digest on each staged release

The staged release published unchanged `bootstrap` source into an empty staging namespace. The feature tarball is not byte-reproducible, so the digest changed.

## Problem

The `java` template in the templates repository added `maven` and `gradle`. Its older pins named `bootstrap@071c527c`, and the new features named `bootstrap@9fab645d`. The template installed `bootstrap` twice and failed. The source of `bootstrap` had not changed.

## Context

* `devcontainer features publish` skips a version that exists. Thus changed source at an existing version also never publishes.
* A consumer pins by digest, so a new digest for the same version breaks a pin set.

## Acceptance criteria

- [x] An unchanged feature keeps its production digest after a release.
- [x] A PR fails if source changed at a version that is already published.

## Resolution

* Date: 2026-09-10. PR #15 (merge `f5227b2`).
* `scripts/check-published-drift.sh --check` runs in `pr-gate` and `make check`. It finds published drift.
* `check-published-drift.sh --seed` runs before each staging publish. It copies identical bytes from production into staging under every production tag.
* `bootstrap` `install.sh` is a no-op when it runs again with the same pins. A contract test covers this.

## Related

* [Published drift check](/supply-chain/published-drift-check--01a1837fdf81.md)
* [Feature dependsOn resolved bootstrap by tag, not by digest](/issues/feature-dependson-resolved-bootstrap-by-tag-not-by-digest--01a183826056.md)
* [The release published to production before a review](/issues/the-release-published-to-production-before-a-review--01a18382607e.md)
* [Supply-chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
