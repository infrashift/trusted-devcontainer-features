---
id: "01a18380-0d2e-7a70-ab41-8d00cf2def51"
title: "Feature: ansible-core"
type: "feature"
tags:
  - "feature"
  - "ansible-core"
  - "ansible"
created: "2026-10-28T12:12:49-05:00"
timestamp: "2026-10-28T12:17:20-05:00"
description: "The ansible-core feature installs a user copy of ansible-core as a uv tool; it is separate from the pinned copy in /opt/bootstrap."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:20-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/features/ansible-core.mdx"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/ansible-core/devcontainer-feature.json"
    title: "ansible-core devcontainer-feature.json"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/tree/main/src/ansible-core/ansible-role-feature"
    title: "ansible-core Ansible role"
---

# Feature: ansible-core

The `ansible-core` feature installs `ansible-core` for the dev user with `uv tool install ansible-core==<version> --python <python>`. It uses the uv in `~/.local/bin` if it exists, or else the bootstrap uv in `/usr/local/bin`. This copy of `ansible-core` is for the playbooks of the user. It is separate from the pinned `ansible-core` in `/opt/bootstrap/.bootstrap` that installs the features.

## Options

Feature version 1.7.2. The defaults are from `src/ansible-core/devcontainer-feature.json` on 2026-10-28.

| Option | Default | Use |
|---|---|---|
| `target_version` | `2.21.5` | The `ansible-core` version. |
| `target_python_version` | `3.14` | The Python that the uv tool uses. |

uv and PyPI resolve the package. The role has no pinned checksum.

## Dependencies

* `dependsOn`: `./bootstrap`. The runtime installs [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) first ([ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md)).
* `installsAfter`: `./python`. This sets the order only. It does not install the other feature.

## Test templates

The test template `ansible-cue` in `test-templates/` uses this feature.

## Notes

* The docs page says that the feature depends on the `python` feature and, through it, on `uv-ruff`. In the code, `python` is only in `installsAfter`, and the role can use the bootstrap uv.

## Related

* [Feature: python](/features/feature-python--01a183801082.md)
* [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) — the other `ansible-core`.
* [ADR-002: Ansible as the feature installer](/decisions/adr-002-ansible-as-the-feature-installer--01a1838011ad.md)
* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
