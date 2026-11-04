---
id: "01a18389-4d6a-793d-ac65-024305c771db"
title: "The npm feature is deprecated only in prose"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "open"
  - "npm"
created: "2026-10-28T12:22:55-05:00"
timestamp: "2026-10-28T12:24:37-05:00"
description: "The npm feature does not set deprecated: true in devcontainer-feature.json, and the dotnet-node test template still installs it."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:24:37-05:00"
status: "draft"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/npm/devcontainer-feature.json"
    title: "npm devcontainer-feature.json"
  - resource: "https://containers.dev/implementors/features/"
    title: "Dev Container Features specification"
---

# The npm feature is deprecated only in prose

The `npm` feature says "Deprecated" in its `description`, but it does not set the `deprecated` property of the Dev Container Features specification. Tools that read the property do not warn the user.

## Problem

* `src/npm/devcontainer-feature.json` has no `"deprecated": true`.
* `test-templates/dotnet-node/.devcontainer/devcontainer.json` line 18 still installs `./npm`. Thus CI tests a deprecated feature together with `nodejs`, which already replaces npm.

## Context

PR #30 moved the npm replacement into `nodejs` through the `npm_version` option. The README and the docs page also do not mark `npm` as deprecated. That is a separate issue.

## Acceptance criteria

- [ ] `src/npm/devcontainer-feature.json` sets `"deprecated": true`, and its version changes.
- [ ] The `dotnet-node` test template does not install `./npm`, or a comment says why it does.

## Related

* [Feature: npm](/features/feature-npm--01a183800fd2.md)
* [Feature: nodejs](/features/feature-nodejs--01a183800fa6.md)
* [Test templates](/architecture/test-templates--01a1837fde68.md)
* [The README and the npm page do not say that npm is deprecated](/issues/the-readme-and-the-npm-page-do-not-say-that-npm-is-deprecated--01a183826637.md)
* [The nodejs feature shipped a bundled npm with known advisories](/issues/the-nodejs-feature-shipped-a-bundled-npm-with-known-advisories--01a183826230.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
