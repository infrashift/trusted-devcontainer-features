---
id: "01a18382-6829-7b18-8180-5e2721f72cbf"
title: "npm 12.2.1 clears 22 of 27 bundled-dependency advisories"
type: "finding"
tags:
  - "finding"
  - "npm"
  - "nodejs"
  - "advisory"
  - "measurement"
created: "2026-10-28T12:15:24-05:00"
timestamp: "2026-10-28T12:20:56-05:00"
description: "On 2026-10-28 an OSV scan found 27 advisories in npm 12.0.2 node_modules and 6 in 12.2.1; undici and ip-address fixes wait upstream."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:56-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/29"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/30"
    title: "PR #30"
stale_after: "2026-11-28T00:00:00Z"
---

# npm 12.2.1 clears 22 of 27 bundled-dependency advisories

On 2026-10-28, an OSV batch scan found 27 published advisories in the `node_modules` of npm 12.0.2 and 6 in npm 12.2.1.

## Source of the measurement

* PR #29 (merged 2026-10-28) ran an OSV batch scan of `node_modules` in both published npm tarballs.
* The 12.0.2 advisories were in `brace-expansion` 5.0.7, `http-cache-semantics` 4.2.0, `ip-address` 10.2.0, `tar` 7.5.19 and `undici` 6.27.0.

## Advisories that stay in npm 12.2.1

| Package in 12.2.1 | Advisories | Fixed in |
|---|---:|---|
| `undici` 6.29.0 | 5, including GHSA-2m5v-pch6-74hx (TLS certificate validation bypass) | 6.29.1 |
| `ip-address` 10.7.2 | 1 (GHSA-rxp7-6hxx-x8q5) | 10.7.4 |

On 2026-10-28, no npm release bundled these fixes.

## Where npm 12.2.1 is installed

* The `nodejs` feature installs it over the bundled npm, through the `npm_version` option (PR #30).
* The deprecated `npm` feature also defaults to 12.2.1.

## Analysis — not part of the measurement

The 6 advisories go away only when npm bundles the fixed `undici` and `ip-address`. A re-pin catches that. `make check-currency` reports the `npm_version` pin, so it shows a new npm release.

## Related

* [Feature: nodejs](/features/feature-nodejs--01a183800fa6.md)
* [Feature: npm](/features/feature-npm--01a183800fd2.md)
* [The nodejs feature shipped a bundled npm with known advisories](/issues/the-nodejs-feature-shipped-a-bundled-npm-with-known-advisories--01a183826230.md)
* [The npm feature shipped a tar with a Critical advisory](/issues/the-npm-feature-shipped-a-tar-with-a-critical-advisory--01a1838261fd.md)
* [On 2026-10-28, kaniko is the only feature pin behind upstream](/findings/on-2026-10-28-kaniko-is-the-only-feature-pin-behind-upstream--01a1838267fd.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
* [Findings overview](/findings/findings-overview--01a1837af700.md)
