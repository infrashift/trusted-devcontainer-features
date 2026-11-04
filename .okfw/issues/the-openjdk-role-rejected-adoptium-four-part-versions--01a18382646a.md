---
id: "01a18382-646a-7ec7-b6c5-67318cf0226e"
title: "The openjdk role rejected Adoptium four-part versions"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "resolved"
  - "openjdk"
created: "2026-10-28T12:15:23-05:00"
timestamp: "2026-10-28T12:20:56-05:00"
description: "The version assert rejected 21.0.12.1+1, an Adoptium emergency patch release; commit c2693a6 allows an optional fourth part."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:56-05:00"
status: "deprecated"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/4"
    title: "PR #4"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/commit/c2693a6"
    title: "Commit c2693a6"
---

# The openjdk role rejected Adoptium four-part versions

The `openjdk` version assert accepted only `X.Y.Z+N`. Adoptium also publishes emergency patch releases such as `21.0.12.1+1`.

## Problem

On 2026-08-23, `21.0.12.1+1` was the newest Temurin 21 GA release. The refresh in PR #4 selected it, and the role failed with `assertion "_openjdk_version is match('^\d+\.\d+\.\d+\+\d+$')" -> false`.

## Context

* The download URL already worked with both forms through `_openjdk_version_underscore`.
* The defect existed before the refresh. Any request for an emergency patch release would have failed.

## Acceptance criteria

- [x] The role accepts a version with an optional fourth part.

## Resolution

* Date: 2026-08-24. PR #4, commit `c2693a6`.
* The same commit added the pinned checksums for cue 0.17.1, which the refresh had missed.

## Related

* [Feature: openjdk](/features/feature-openjdk--01a18380102a.md)
* [Feature tool pins were far behind upstream](/issues/feature-tool-pins-were-far-behind-upstream--01a183826297.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
