---
id: "01a18382-6230-774b-8441-21526bb74eb3"
title: "The nodejs feature shipped a bundled npm with known advisories"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "resolved"
  - "cve"
  - "nodejs"
  - "npm"
created: "2026-10-28T12:15:22-05:00"
timestamp: "2026-10-28T12:20:56-05:00"
description: "Node.js 22.23.4 bundles npm 10.9.9 with about 22 advisories; PR #30 replaces it with npm_version and deprecates the npm feature."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:56-05:00"
status: "deprecated"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/30"
    title: "PR #30"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/29"
    title: "PR #29"
---

# The nodejs feature shipped a bundled npm with known advisories

Node.js 22.23.4 bundles npm 10.9.9. Its vendored dependencies have about 22 published advisories. A template that installed `nodejs` without the `npm` feature shipped them.

## Problem

Only the separate `npm` feature replaced the bundled npm. A `dependsOn` from `nodejs` to `npm` does not work, for three reasons. It has no either-or. It installs npm before Node.js. The two-phase release supports only dependencies on `bootstrap`.

## Context

* npm 12 needs Node.js 22.22.2 or later on the 22 line.
* "2.2.1" is a substring of "12.2.1". A substring check could mistake a mismatch for a match.

## Acceptance criteria

- [x] `nodejs` replaces its bundled npm with the version in the `npm_version` option.
- [x] The role compares the npm version exactly.
- [x] The `extras` template asserts that `npm --version` is 12.2.1.
- [x] `check-version-currency.sh` reports the `npm_version` pin.

## Resolution

* Date: 2026-10-28. PR #30 (merge `8f7b695`).
* `nodejs` moved from 1.5.4 to 1.6.0, with `npm_version` default 12.2.1. The npm cache goes to `/tmp` and the role removes it.
* `npm` moved from 1.8.0 to 1.8.1 and its description says that it is deprecated. The feature stays, so existing configurations still build.

## Related

* [Feature: nodejs](/features/feature-nodejs--01a183800fa6.md)
* [The npm feature shipped a tar with a Critical advisory](/issues/the-npm-feature-shipped-a-tar-with-a-critical-advisory--01a1838261fd.md)
* [npm 12.2.1 clears 22 of 27 bundled-dependency advisories](/findings/npm-12-2-1-clears-22-of-27-bundled-dependency-advisories--01a183826829.md)
* [The README and the npm page do not say that npm is deprecated](/issues/the-readme-and-the-npm-page-do-not-say-that-npm-is-deprecated--01a183826637.md)
* [The getting-started Node.js example fails with the default npm](/issues/the-getting-started-node-js-example-fails-with-the-default-npm--01a1838265fc.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
