---
id: "01a18382-6637-721b-abbd-19a4f911372b"
title: "The README and the npm page do not say that npm is deprecated"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "open"
  - "docs"
  - "npm"
created: "2026-10-28T12:15:23-05:00"
timestamp: "2026-10-28T12:20:48-05:00"
description: "PR #30 deprecated the npm feature, but README.md and the npm.mdx description still offer it as a normal feature."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:48-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/README.md"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/features/npm.mdx"
    title: "docs/src/content/docs/features/npm.mdx"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/30"
    title: "PR #30"
---

# The README and the npm page do not say that npm is deprecated

PR #30 deprecated the `npm` feature. Two pages still offer it as a normal feature.

## Problem

* `README.md` line 28 describes `npm` as "Updates npm to a specific version".
* `docs/src/content/docs/features/npm.mdx` line 3 has the old `description` in its frontmatter.

## Context

* `src/npm/devcontainer-feature.json` and `docs/src/data/features.json` start the description with "Deprecated:".
* PR #30 says that the deprecation is in the description, `NOTES.md` and the docs.

## Acceptance criteria

- [ ] `README.md` marks `npm` as deprecated and points to the `nodejs` option `npm_version`.
- [ ] The `npm.mdx` frontmatter and page say that the feature is deprecated.

## Related

* [Feature: npm](/features/feature-npm--01a183800fd2.md)
* [The nodejs feature shipped a bundled npm with known advisories](/issues/the-nodejs-feature-shipped-a-bundled-npm-with-known-advisories--01a183826230.md)
* [The getting-started Node.js example fails with the default npm](/issues/the-getting-started-node-js-example-fails-with-the-default-npm--01a1838265fc.md)
* [Bring the docs site in line with the code](/plans/bring-the-docs-site-in-line-with-the-code--01a1838268e3.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
