---
id: "01a18380-0fd2-71ae-b1fb-301a23216e19"
title: "Feature: npm"
type: "feature"
tags:
  - "feature"
  - "npm"
  - "nodejs"
  - "deprecated"
created: "2026-10-28T12:12:50-05:00"
timestamp: "2026-10-28T12:17:22-05:00"
description: "Deprecated: the nodejs feature now replaces its bundled npm, so the npm feature does nothing at the default versions."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:22-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/features/npm.mdx"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/npm/devcontainer-feature.json"
    title: "npm devcontainer-feature.json"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/tree/main/src/npm/ansible-role-feature"
    title: "npm Ansible role"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/30"
    title: "PR #30: deprecate the npm feature"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/commit/127079b9f5518f71fb5e5505a018f577eb4ee6d3"
    title: "Commit 127079b"
---

# Feature: npm

The `npm` feature is deprecated. The `nodejs` feature ([Feature: nodejs](/features/feature-nodejs--01a183800fa6.md)) now replaces its bundled npm with the version in its `npm_version` option. The `npm` feature stays so that the `devcontainer.json` files that use it still build. At the default versions it does nothing, because both features install the same npm ([PR #30](https://github.com/infrashift/trusted-devcontainer-features/pull/30)).

## Options

Feature version 1.8.1. The defaults are from `src/npm/devcontainer-feature.json` on 2026-10-28.

| Option | Default | Use |
|---|---|---|
| `target_version` | `12.2.1` | The npm version. |

## How it installs

The role runs `~/.local/share/nodejs/bin/npm install -g npm@<version>` and asserts the version. It needs the Node.js of the `nodejs` feature.

## Dependencies

* `dependsOn`: `./bootstrap`. The runtime installs [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) first ([ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md)).
* `installsAfter`: `./nodejs`. This sets the order only. It does not install the other feature.

## Test templates

The test template `dotnet-node` in `test-templates/` uses this feature.

## Notes

* Only the `description` in `devcontainer-feature.json` says "Deprecated". The file does not set the `deprecated` property of the dev container feature specification.
* The docs page does not say that the feature is deprecated. It also says that the feature declares `nodejs` as a dependency. The code has `nodejs` only in `installsAfter`.
* The `dotnet-node` test template still uses `./npm`.

## Related

* [The npm feature shipped a tar with a Critical advisory](/issues/the-npm-feature-shipped-a-tar-with-a-critical-advisory--01a1838261fd.md)
* [npm 12.2.1 clears 22 of 27 bundled-dependency advisories](/findings/npm-12-2-1-clears-22-of-27-bundled-dependency-advisories--01a183826829.md)
* [The README and the npm page do not say that npm is deprecated](/issues/the-readme-and-the-npm-page-do-not-say-that-npm-is-deprecated--01a183826637.md)
* [The npm feature is deprecated only in prose](/issues/the-npm-feature-is-deprecated-only-in-prose--01a183894d6a.md)
* [Feature: nodejs](/features/feature-nodejs--01a183800fa6.md) — the replacement.
* [ADR-007: installsAfter dependency model](/decisions/adr-007-installsafter-dependency-model--01a183801281.md) — the old dependency `npm` after `nodejs`.
* [Features overview](/features/features-overview--01a1837af6b6.md)
