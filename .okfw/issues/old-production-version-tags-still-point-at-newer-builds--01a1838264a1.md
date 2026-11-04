---
id: "01a18382-64a1-7b3f-a857-037e483109aa"
title: "Old production version tags still point at newer builds"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "open"
  - "release"
created: "2026-10-28T12:15:23-05:00"
timestamp: "2026-10-28T12:20:47-05:00"
description: "PR #23 stopped the tag moves but did not restore the tags that earlier releases moved; jq 1.4.0 to 1.5.1 resolve to 1.5.2."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:47-05:00"
status: "draft"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/23"
    title: "PR #23"
---

# Old production version tags still point at newer builds

[Promotion moved old version tags onto the newest build](/issues/promotion-moved-old-version-tags-onto-the-newest-build--01a1838260cd.md) stopped new tag moves. PR #23 did not restore the tags that earlier releases had moved.

## Problem

A consumer who pins a feature by an old version tag gets a newer build, not the build of that version. The version tag gives a false record of what the version contains.

## Context

* PR #23 states: "production tags already moved by earlier releases here are not restored."
* Measured on 2026-10-28: in production, the `jq` tags `1.4.0`, `1.5.0`, `1.5.1` and `1.5.2` all have one manifest digest. See [On 2026-10-28, jq tags 1.4.0 to 1.5.1 resolve to the 1.5.2 build](/findings/on-2026-10-28-jq-tags-1-4-0-to-1-5-1-resolve-to-the-1-5-2-build--01a183826888.md).
* The templates pin features by digest, so a template build is not affected. A consumer who uses a version tag is affected.
* Releases before PR #23 promoted every feature, so other features probably have the same state. Only `jq` was measured.

## Acceptance criteria

- [ ] A script lists, for each feature, the production version tags whose digest is not the build of that version.
- [ ] Each moved tag points at its own build again, or the gap is recorded as accepted.

## Related

* [Release workflow](/supply-chain/release-workflow--01a1837fdeee.md)
* [Stage, review and promote by digest](/supply-chain/stage-review-and-promote-by-digest--01a1837fdf62.md)
* [Promotion moved old version tags onto the newest build](/issues/promotion-moved-old-version-tags-onto-the-newest-build--01a1838260cd.md)
* [On 2026-10-28, jq tags 1.4.0 to 1.5.1 resolve to the 1.5.2 build](/findings/on-2026-10-28-jq-tags-1-4-0-to-1-5-1-resolve-to-the-1-5-2-build--01a183826888.md)
* [Supply-chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
