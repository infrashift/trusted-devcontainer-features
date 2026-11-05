---
id: "01a1837a-f700-74af-a779-8813185d5de9"
title: "Findings overview"
type: "overview"
tags:
  - "hub"
  - "finding"
created: "2026-10-28T12:07:16-05:00"
timestamp: "2026-10-28T12:07:16-05:00"
description: "Measured facts that have a date: advisory counts, version currency and scan results."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:07:16-05:00"
status: "draft"
---

# Findings overview

This bundle holds one concept for each measured fact. Each finding has a date, a source, and a `stale_after` date when the fact can expire.

Do not put problems to fix here. Put them in `issues/` and link the finding.

## Find concepts

* List this bundle: read `.okfw/findings/index.md`.
* Search this bundle: `okfw search "<words>" --type finding`.

## Add a concept

1. Search the wiki first. If a finding measures the same thing, add the new run to it.
2. Run `okfw create "<Title>" --path findings --type finding -d "<one sentence>" --tags finding`.
3. Put the date in the title or the first sentence. Give the command or the source of the measurement.
4. Put your analysis under a heading that says "Analysis — not part of the measurement".
5. If the fact can expire, run `okfw set-stale-after <id> <datetime>`.
6. Add a link to the new finding in the list below.

## Concepts

### Version currency and advisories

* [On 2026-10-28, kaniko is the only feature pin behind upstream](/findings/on-2026-10-28-kaniko-is-the-only-feature-pin-behind-upstream--01a1838267fd.md) — `make check-currency` result, with the first run of 2026-08-24
* [npm 12.2.1 clears 22 of 27 bundled-dependency advisories](/findings/npm-12-2-1-clears-22-of-27-bundled-dependency-advisories--01a183826829.md) — OSV scan from PR #29; 6 advisories wait upstream
* [On 2026-08-23, stale feature tool pins caused most template CVE findings](/findings/on-2026-08-23-stale-feature-tool-pins-caused-most-template-cve-findings--01a183826856.md) — the first templates CVE gate run

### Version changes

* [On 2026-11-04, the SDK 10 default of dotnet 2.0.0 breaks consumers that run net8.0](/findings/on-2026-11-04-the-sdk-10-default-of-dotnet-2-0-0-breaks-consumers-that-run-net8-0--01a1aa473917.md) — who breaks when the default SDK moves from 8 to 10

### Registry state

* [On 2026-10-28, jq tags 1.4.0 to 1.5.1 resolve to the 1.5.2 build](/findings/on-2026-10-28-jq-tags-1-4-0-to-1-5-1-resolve-to-the-1-5-2-build--01a183826888.md) — old version tags that promotion moved

## Related

* [Wiki map](/wiki-map--01a1837af671.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
* [Supply-chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
* [Simplified Technical English](/guides/simplified-technical-english--01a1837af766.md)
