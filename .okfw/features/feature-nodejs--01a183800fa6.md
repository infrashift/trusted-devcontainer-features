---
id: "01a18380-0fa6-749d-aec8-d024d76f5aa3"
title: "Feature: nodejs"
type: "feature"
tags:
  - "feature"
  - "nodejs"
  - "npm"
created: "2026-10-28T12:12:50-05:00"
timestamp: "2026-10-28T12:17:22-05:00"
description: "The nodejs feature installs Node.js from nodejs.org and replaces the bundled npm with the version in the npm_version option."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:22-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/features/nodejs.mdx"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/nodejs/devcontainer-feature.json"
    title: "nodejs devcontainer-feature.json"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/tree/main/src/nodejs/ansible-role-feature"
    title: "nodejs Ansible role"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/30"
    title: "PR #30: nodejs replaces its bundled npm"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/commit/127079b9f5518f71fb5e5505a018f577eb4ee6d3"
    title: "Commit 127079b"
---

# Feature: nodejs

The `nodejs` feature installs Node.js from `nodejs.org` into `~/.local/share/nodejs` and then replaces the bundled npm with the version in `npm_version`. If `target_checksum` is empty, the role takes the SHA256 checksum of the tarball from `SHASUMS256.txt` of the release. It links `node`, `npm` and `npx` into `~/.local/bin`. The npm replacement came in nodejs 1.6.0, because the bundled npm had published advisories ([commit 127079b](https://github.com/infrashift/trusted-devcontainer-features/commit/127079b9f5518f71fb5e5505a018f577eb4ee6d3)).

## Options

Feature version 1.6.0. The defaults are from `src/nodejs/devcontainer-feature.json` on 2026-10-28.

| Option | Default | Use |
|---|---|---|
| `target_version` | `22.23.4` | The Node.js version. |
| `target_checksum` | empty | Empty: use `SHASUMS256.txt` of the release. |
| `npm_version` | `12.2.1` | The npm that replaces the bundled npm. npm 12 needs Node.js `^22.22.2`, `^24.15.0` or `>=26`. |

`npm install -g` verifies the npm tarball against the sha512 integrity value of the registry.

## Dependencies

* `dependsOn`: `./bootstrap`. The runtime installs [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) first ([ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md)).
* `installsAfter`: none.

## Test templates

The test templates `dotnet-node`, `extras` in `test-templates/` use this feature.

## Notes

* The docs page says to add the `npm` feature for a different npm. That is out of date: use the `npm_version` option.
* The docs page names a `.tar.xz` file and a pinned checksum. The code downloads `.tar.gz` and uses `SHASUMS256.txt`.

## Related

* [The nodejs feature shipped a bundled npm with known advisories](/issues/the-nodejs-feature-shipped-a-bundled-npm-with-known-advisories--01a183826230.md)
* [npm 12.2.1 clears 22 of 27 bundled-dependency advisories](/findings/npm-12-2-1-clears-22-of-27-bundled-dependency-advisories--01a183826829.md)
* [The getting-started Node.js example fails with the default npm](/issues/the-getting-started-node-js-example-fails-with-the-default-npm--01a1838265fc.md)
* [Feature: npm](/features/feature-npm--01a183800fd2.md) — deprecated by this feature.
* [Feature: pnpm](/features/feature-pnpm--01a183801056.md)
* [Feature: claude-code](/features/feature-claude-code--01a183800d91.md)
* [ADR-006: Checksum verification](/decisions/adr-006-checksum-verification--01a183801256.md)
* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md) — the checksums-file exemption.
* [Features overview](/features/features-overview--01a1837af6b6.md)
