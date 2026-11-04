---
id: "01a18380-1130-7bdb-8398-a07f5f4fcad9"
title: "Feature: uv-ruff"
type: "feature"
tags:
  - "feature"
  - "uv-ruff"
  - "uv"
  - "python"
created: "2026-10-28T12:12:50-05:00"
timestamp: "2026-10-28T12:17:22-05:00"
description: "The uv-ruff feature installs uv for the dev user from a checksum-verified tarball, then installs Ruff with uv tool install."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:22-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/features/uv-ruff.mdx"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/uv-ruff/devcontainer-feature.json"
    title: "uv-ruff devcontainer-feature.json"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/tree/main/src/uv-ruff/ansible-role-feature"
    title: "uv-ruff Ansible role"
---

# Feature: uv-ruff

The `uv-ruff` feature installs uv and Ruff for the dev user. The role downloads the uv tarball from the `astral-sh/uv` GitHub releases, verifies it against a pinned SHA256 checksum, and puts `uv` and `uvx` in `~/.local/bin`. Then it runs `uv tool install ruff==<version>`. This uv is separate from `/usr/local/bin/uv`, which the `bootstrap` feature installs.

## Options

Feature version 1.7.0. The defaults are from `src/uv-ruff/devcontainer-feature.json` on 2026-10-28.

| Option | Default | Use |
|---|---|---|
| `target_uv_version` | `0.13.6` | The uv version. |
| `target_uv_checksum` | empty | Empty: use the pinned uv checksum. |
| `target_ruff_version` | `0.17.3` | The Ruff version. uv and PyPI resolve it. |

## Dependencies

* `dependsOn`: `./bootstrap`. The runtime installs [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) first ([ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md)).
* `installsAfter`: none.

## Test templates

The test template `python` in `test-templates/` uses this feature.

## Related

* [uv 0.12.5 installed CPython 3.14.7, which has two CVEs](/issues/uv-0-12-5-installed-cpython-3-14-7-which-has-two-cves--01a1838261cb.md)
* [Feature: python](/features/feature-python--01a183801082.md)
* [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) — the other uv.
* [ADR-006: Checksum verification](/decisions/adr-006-checksum-verification--01a183801256.md)
* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
