---
id: "01a18380-0ffe-755f-b1d5-63281a825ae0"
title: "Feature: openai-codex"
type: "feature"
tags:
  - "feature"
  - "openai-codex"
  - "bun"
created: "2026-10-28T12:12:50-05:00"
timestamp: "2026-10-28T12:17:21-05:00"
description: "The openai-codex feature installs the OpenAI Codex CLI with bun install -g; it resolves the npm dist-tag latest to an exact version first."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:21-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/features/openai-codex.mdx"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/openai-codex/devcontainer-feature.json"
    title: "openai-codex devcontainer-feature.json"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/tree/main/src/openai-codex/ansible-role-feature"
    title: "openai-codex Ansible role"
---

# Feature: openai-codex

The `openai-codex` feature installs the OpenAI Codex CLI with `bun install -g @openai/codex@<version>`. If `target_version` is an npm dist-tag such as `latest`, the role first asks `registry.npmjs.org` for the exact version. Thus the install is pinned, and the role asserts the exact version. The binary is in `~/.bun/bin`, and the role links `codex` into `~/.local/bin`.

## Options

Feature version 1.4.3. The defaults are from `src/openai-codex/devcontainer-feature.json` on 2026-10-28.

| Option | Default | Use |
|---|---|---|
| `target_version` | `latest` | An npm dist-tag or an exact version. |

The role has no checksum option. Bun verifies the package from the npm registry.

## Dependencies

* `dependsOn`: `./bootstrap`. The runtime installs [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) first ([ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md)).
* `installsAfter`: `./bun`, `./nodejs`. This sets the order only. It does not install the other feature.
* The role runs `~/.local/bin/bun`. Add the `bun` feature in `devcontainer.json`, because `installsAfter` does not install it.

## Test templates

The test template `extras` in `test-templates/` uses this feature.

## Notes

* The docs page says that the dependency chain installs Bun automatically. The code has `bun` only in `installsAfter`.
* The `claude-code` role passes `--trust` to `bun install`. This role does not.

## Related

* [claude-code and openai-codex did not upgrade from latest](/issues/claude-code-and-openai-codex-did-not-upgrade-from-latest--01a18382642c.md)
* [Feature: bun](/features/feature-bun--01a183800d6f.md)
* [Feature: claude-code](/features/feature-claude-code--01a183800d91.md) — the same install shape.
* [ADR-005: Bun as the package manager](/decisions/adr-005-bun-as-the-package-manager--01a18380122a.md)
* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
