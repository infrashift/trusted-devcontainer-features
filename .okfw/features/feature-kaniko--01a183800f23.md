---
id: "01a18380-0f23-742e-8b4a-9628d38e63c6"
title: "Feature: kaniko"
type: "feature"
tags:
  - "feature"
  - "kaniko"
created: "2026-10-28T12:12:50-05:00"
timestamp: "2026-10-28T12:17:21-05:00"
description: "The kaniko feature downloads one pinned image layer each for the kaniko executor and the cache warmer from the registry."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:21-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/features/kaniko.mdx"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/kaniko/devcontainer-feature.json"
    title: "kaniko devcontainer-feature.json"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/tree/main/src/kaniko/ansible-role-feature"
    title: "kaniko Ansible role"
---

# Feature: kaniko

The `kaniko` feature installs the kaniko executor and the cache warmer as `kaniko-executor` and `kaniko-warmer`. kaniko has no release binaries, so the role downloads one layer of the `ghcr.io/osscontainertools/kaniko` image for each binary. Each pinned layer digest is both the download URL and the checksum. The binaries go into `~/.local/share/kaniko/<version>/` with links in `~/.local/bin`.

## Options

Feature version 1.1.3. The defaults are from `src/kaniko/devcontainer-feature.json` on 2026-10-28.

| Option | Default | Use |
|---|---|---|
| `target_version` | `1.28.6` | The kaniko version. |
| `target_executor_checksum` | empty | Empty: use the pinned layer digest of the executor. |
| `target_warmer_checksum` | empty | Empty: use the pinned layer digest of the warmer. |

## Dependencies

* `dependsOn`: `./bootstrap`. The runtime installs [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) first ([ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md)).
* `installsAfter`: none.

## Test templates

The test template `infra` in `test-templates/` uses this feature.

## Notes

* The executor changes the root file system of the container that it runs in. The docs page and `src/kaniko/NOTES.md` say to run it in a chroot.

## Related

* [The kaniko role cannot install kaniko 1.29 or later](/issues/the-kaniko-role-cannot-install-kaniko-1-29-or-later--01a1838266c2.md)
* [On 2026-10-28, kaniko is the only feature pin behind upstream](/findings/on-2026-10-28-kaniko-is-the-only-feature-pin-behind-upstream--01a1838267fd.md)
* [Feature: envbuilder](/features/feature-envbuilder--01a183800e01.md) — the same layer-download shape.
* [ADR-006: Checksum verification](/decisions/adr-006-checksum-verification--01a183801256.md)
* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
