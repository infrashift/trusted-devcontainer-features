---
id: "01a18382-62eb-7b7f-b95c-a7b3b822c374"
title: "No check reported how far pinned tools were behind upstream"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "resolved"
  - "version-currency"
created: "2026-10-28T12:15:22-05:00"
timestamp: "2026-10-28T12:20:56-05:00"
description: "Two refresh rounds found stale tools only through CVE reports; PR #5 adds check-version-currency.sh, which warns in pr-gate."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:56-05:00"
status: "deprecated"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/5"
    title: "PR #5"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/29"
    title: "PR #29"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/check-version-currency.sh"
---

# No check reported how far pinned tools were behind upstream

Two refresh rounds found tools far behind upstream. A CVE report showed each gap. No check showed it.

## Problem

The templates CVE gate records findings in vendored dependencies instead of blocking them. That is correct only while the tools stay current. Without a currency check, the next drift would cause no signal.

## Context

* A release that is one hour old must not fail a build. So the check warns and does not block.
* `node`, `dotnet` and `openjdk` resolve within their declared major line.

## Acceptance criteria

- [x] A script compares each pinned default with the newest upstream release.
- [x] The script reports a failed lookup as `unknown`, never as `current`.
- [x] `pr-gate` runs it on each PR.

## Resolution

* Date: 2026-08-24. PR #5 (merge `9e10e70`) added `scripts/check-version-currency.sh` and `make check-currency`. It has a `--max-behind N` option for a future threshold.
* The first run reported 11 current, 3 behind (`bun`, `npm`, `pnpm`), 4 not comparable and 0 unknown.
* PR #12 added retries. PR #29 read npm dist-tags instead of the full packument, which had made npm `unknown`.
* Some pins are still outside the check. See [The currency check skips the bootstrap, ruff and sqlpackage pins](/issues/the-currency-check-skips-the-bootstrap-ruff-and-sqlpackage-pins--01a183826696.md).

## Related

* [Version currency check](/supply-chain/version-currency-check--01a1837fdfe4.md)
* [On 2026-10-28, kaniko is the only feature pin behind upstream](/findings/on-2026-10-28-kaniko-is-the-only-feature-pin-behind-upstream--01a1838267fd.md)
* [The currency check skips the bootstrap, ruff and sqlpackage pins](/issues/the-currency-check-skips-the-bootstrap-ruff-and-sqlpackage-pins--01a183826696.md)
* [Feature tool pins were far behind upstream](/issues/feature-tool-pins-were-far-behind-upstream--01a183826297.md)
* [Supply-chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
