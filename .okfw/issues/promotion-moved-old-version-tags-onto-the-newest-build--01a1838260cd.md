---
id: "01a18382-60cd-79b7-bd68-dd8cdfd8cf6f"
title: "Promotion moved old version tags onto the newest build"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "resolved"
  - "release"
created: "2026-10-28T12:15:22-05:00"
timestamp: "2026-10-28T12:20:56-05:00"
description: "promote-features.sh copied every staging tag onto the reviewed digest; PR #23 promotes only the tags that staging holds on that digest."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:56-05:00"
status: "deprecated"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/23"
    title: "PR #23"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/promote-features.sh"
---

# Promotion moved old version tags onto the newest build

`promote-features.sh` copied every tag in a staging repository onto the reviewed digest. Old version tags in production then pointed at the newest build.

## Problem

Staging keeps the tags of earlier releases, each on its own build. The promotion loop did not check which digest a tag had in staging. Thus each release moved all historical version tags in production onto the new build.

## Context

* The templates repository had the same loop. On 2026-10-09 it moved the `lazyvim` tags `1.0.0` to `1.2.0` onto 1.2.1.
* The fix had to be in place before PR #24, which promoted all 27 features in one release.

## Acceptance criteria

- [x] Promotion copies a tag only when staging resolves that tag to the reviewed digest.
- [x] Promotion logs each tag that it leaves.
- [ ] Tags that earlier releases moved point at their own builds again. See [Old production version tags still point at newer builds](/issues/old-production-version-tags-still-point-at-newer-builds--01a1838264a1.md).

## Resolution

* Date: 2026-10-09. PR #23 (merge `cc2dcff`).
* A tag that staging holds on another digest stays. The script prints `leave <feature>:<tag> -- staging holds it on …`.
* PR #23 tested the change offline with a stub `crane`. The PR did not restore the tags that earlier releases moved.

## Related

* [Release workflow](/supply-chain/release-workflow--01a1837fdeee.md)
* [Stage, review and promote by digest](/supply-chain/stage-review-and-promote-by-digest--01a1837fdf62.md)
* [Old production version tags still point at newer builds](/issues/old-production-version-tags-still-point-at-newer-builds--01a1838264a1.md)
* [On 2026-10-28, jq tags 1.4.0 to 1.5.1 resolve to the 1.5.2 build](/findings/on-2026-10-28-jq-tags-1-4-0-to-1-5-1-resolve-to-the-1-5-2-build--01a183826888.md)
* [The release published to production before a review](/issues/the-release-published-to-production-before-a-review--01a18382607e.md)
* [Supply-chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
