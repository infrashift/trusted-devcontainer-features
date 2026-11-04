---
id: "01a18382-65fc-710c-957d-04c458c6a052"
title: "The getting-started Node.js example fails with the default npm"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "open"
  - "docs"
  - "nodejs"
created: "2026-10-28T12:15:23-05:00"
timestamp: "2026-10-28T12:20:48-05:00"
description: "getting-started.md sets nodejs target_version 22.16.0, but the default npm_version 12.2.1 needs Node.js 22.22.2 or later."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:48-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/getting-started.md"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/nodejs/devcontainer-feature.json"
    title: "src/nodejs/devcontainer-feature.json"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/30"
    title: "PR #30"
---

# The getting-started Node.js example fails with the default npm

The first example in `docs/src/content/docs/getting-started.md` (line 22) sets the `nodejs` option `target_version` to `22.16.0`. With the default `npm_version`, that build fails.

## Problem

Since PR #30, `nodejs` replaces its bundled npm with `npm_version`, default `12.2.1`. npm 12 needs Node.js `^22.22.2 || ^24.15.0 || >=26`. A user who copies the example gets Node.js 22.16.0 and npm 12.2.1, and the post-install assert fails.

## Context

* `src/nodejs/devcontainer-feature.json` line 14 says: with a Node.js older than 22.22.2, also set `npm_version` to a 10.x release.
* The same page (line 66) lists `npm` as a feature that depends on `nodejs`. The `npm` feature is deprecated.

## Acceptance criteria

- [ ] The example uses a Node.js version that the default npm supports, or also sets `npm_version`.
- [ ] The dependency table does not offer the `npm` feature as a normal feature.

## Related

* [Feature: nodejs](/features/feature-nodejs--01a183800fa6.md)
* [The nodejs feature shipped a bundled npm with known advisories](/issues/the-nodejs-feature-shipped-a-bundled-npm-with-known-advisories--01a183826230.md)
* [The README and the npm page do not say that npm is deprecated](/issues/the-readme-and-the-npm-page-do-not-say-that-npm-is-deprecated--01a183826637.md)
* [Bring the docs site in line with the code](/plans/bring-the-docs-site-in-line-with-the-code--01a1838268e3.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
