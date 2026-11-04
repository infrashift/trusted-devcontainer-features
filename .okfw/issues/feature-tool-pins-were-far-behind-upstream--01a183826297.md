---
id: "01a18382-6297-7955-85fa-4f81699d8f01"
title: "Feature tool pins were far behind upstream"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "resolved"
  - "cve"
  - "version-currency"
created: "2026-10-28T12:15:22-05:00"
timestamp: "2026-10-28T12:20:56-05:00"
description: "On 2026-08-23 old tool versions in the features caused most template CVE findings; PRs #3 and #4 move them to current releases."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:56-05:00"
status: "deprecated"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/3"
    title: "PR #3"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/4"
    title: "PR #4"
---

# Feature tool pins were far behind upstream

On 2026-08-23 the first templates CVE gate run failed all five templates. Most blocking findings came from old tool versions that these features install.

## Problem

The features pinned old releases. For example, the features shipped syft 1.42.0 and grype 0.108.0, but `tools.lock` already pinned syft v1.51.0 and grype v0.117.0 for CI. The old binaries were built with go1.25.1 and had old vendored Go modules.

## Context

* The measurement is in [On 2026-08-23, stale feature tool pins caused most template CVE findings](/findings/on-2026-08-23-stale-feature-tool-pins-caused-most-template-cve-findings--01a183826856.md).
* A major version change is a behavior change. Both PRs moved each tool only to the newest release on its current line.

## Acceptance criteria

- [x] Each tool that contributed blocking findings moves to the newest release on its line.
- [x] Each new checksum comes from an upstream source and matches a second source.

## Resolution

* Date: 2026-08-24. PR #3 (merge `e270b4a`): syft, grype, yq and jq.
* Date: 2026-08-24. PR #4 (merge `3b98e3a`): go, cue, node, npm, dotnet, openjdk, uv and ruff.
* Old versions stay in the checksum tables, so a request for an old version still verifies.
* PR #5 added a check so that the next drift is visible. See [No check reported how far pinned tools were behind upstream](/issues/no-check-reported-how-far-pinned-tools-were-behind-upstream--01a1838262eb.md).

## Related

* [On 2026-08-23, stale feature tool pins caused most template CVE findings](/findings/on-2026-08-23-stale-feature-tool-pins-caused-most-template-cve-findings--01a183826856.md)
* [No check reported how far pinned tools were behind upstream](/issues/no-check-reported-how-far-pinned-tools-were-behind-upstream--01a1838262eb.md)
* [Test copies of the version defaults drifted from the declared defaults](/issues/test-copies-of-the-version-defaults-drifted-from-the-declared-defaults--01a1838262c3.md)
* [The openjdk role rejected Adoptium four-part versions](/issues/the-openjdk-role-rejected-adoptium-four-part-versions--01a18382646a.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
