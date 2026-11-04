---
id: "01a18382-61fd-7e14-9ed6-021a5e14e265"
title: "The npm feature shipped a tar with a Critical advisory"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "resolved"
  - "cve"
  - "npm"
created: "2026-10-28T12:15:22-05:00"
timestamp: "2026-10-28T12:20:56-05:00"
description: "npm 11.9.0 bundled tar 7.5.7 with GHSA-23hp-3jrh-7fpw, the last blocking template finding; PR #6 moves the npm feature to npm 12.0.2."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:56-05:00"
status: "deprecated"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/6"
    title: "PR #6"
---

# The npm feature shipped a tar with a Critical advisory

npm 11.9.0 bundled `tar` 7.5.7, which has GHSA-23hp-3jrh-7fpw (Critical, fixed in 7.5.19). It was the last blocking finding in the five templates.

## Problem

The finding was in `~/.local/share/nodejs/lib/node_modules/npm/node_modules/tar`. The `npm` feature replaces the npm of Node.js in place, so the fix belonged in the `npm` feature. npm 11.9.0 was the last 11.x release, so no 11.x patch could fix it.

## Context

* npm 12.0.2 bundles `tar` `^7.5.19`.
* npm 12 needs Node.js `^22.22.2 || ^24.15.0 || >=26.0.0`. The pinned Node.js 22.23.2 satisfied it.
* The smoke test asserts only `npm --version`. It does not test the behavior of npm 12.

## Acceptance criteria

- [x] The `npm` feature installs an npm that bundles a fixed `tar`.
- [x] The option description states the new Node.js floor.

## Resolution

* Date: 2026-08-24. PR #6 (merge `f9f824d`).
* The `npm` feature moved to npm 12.0.2. The option proposals became `["11.9.0", "10.9.2"]`.
* Later, PR #29 moved it to 12.2.1, and PR #30 deprecated the feature. See [The nodejs feature shipped a bundled npm with known advisories](/issues/the-nodejs-feature-shipped-a-bundled-npm-with-known-advisories--01a183826230.md).

## Related

* [Feature: npm](/features/feature-npm--01a183800fd2.md)
* [The nodejs feature shipped a bundled npm with known advisories](/issues/the-nodejs-feature-shipped-a-bundled-npm-with-known-advisories--01a183826230.md)
* [npm 12.2.1 clears 22 of 27 bundled-dependency advisories](/findings/npm-12-2-1-clears-22-of-27-bundled-dependency-advisories--01a183826829.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
