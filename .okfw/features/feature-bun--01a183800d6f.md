---
id: "01a18380-0d6f-778b-ae3e-cb4c67cd9702"
title: "Feature: bun"
type: "feature"
tags:
  - "feature"
  - "bun"
created: "2026-10-28T12:12:49-05:00"
timestamp: "2026-10-28T12:17:21-05:00"
description: "The bun feature installs the Bun JavaScript runtime from a GitHub release zip, verified against a pinned SHA256 checksum."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:21-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/features/bun.mdx"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/bun/devcontainer-feature.json"
    title: "bun devcontainer-feature.json"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/tree/main/src/bun/ansible-role-feature"
    title: "bun Ansible role"
---

# Feature: bun

The `bun` feature installs the Bun JavaScript runtime and package manager. The role downloads `bun-linux-x64.zip` or `bun-linux-aarch64.zip` from the GitHub release and verifies it against a pinned SHA256 checksum. It copies the `bun` binary into `~/.local/bin`. Bun installs the `claude-code` and `openai-codex` CLIs ([ADR-005: Bun as the package manager](/decisions/adr-005-bun-as-the-package-manager--01a18380122a.md)).

## Options

Feature version 1.5.0. The defaults are from `src/bun/devcontainer-feature.json` on 2026-10-28.

| Option | Default | Use |
|---|---|---|
| `target_version` | `1.4.4` | The Bun version. |
| `target_checksum` | empty | Empty: use the pinned checksum. Required for a version that has no pin. |

## Dependencies

* `dependsOn`: `./bootstrap`. The runtime installs [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) first ([ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md)).
* `installsAfter`: none.

## Test templates

The test template `extras` in `test-templates/` uses this feature.

## Notes

* The docs page says that the role downloads a tarball and that dependent features install Bun automatically. The code downloads a zip. `claude-code` and `openai-codex` have Bun only in `installsAfter`, so they do not install it.

## Related

* [Feature docs pages disagree with the code](/issues/feature-docs-pages-disagree-with-the-code--01a183894c2e.md)
* [Feature: claude-code](/features/feature-claude-code--01a183800d91.md)
* [Feature: openai-codex](/features/feature-openai-codex--01a183800ffe.md)
* [ADR-005: Bun as the package manager](/decisions/adr-005-bun-as-the-package-manager--01a18380122a.md)
* [ADR-006: Checksum verification](/decisions/adr-006-checksum-verification--01a183801256.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
