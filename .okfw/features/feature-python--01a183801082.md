---
id: "01a18380-1082-7e6b-8d4d-921f3ea306f6"
title: "Feature: python"
type: "feature"
tags:
  - "feature"
  - "python"
  - "uv"
created: "2026-10-28T12:12:50-05:00"
timestamp: "2026-10-28T12:17:22-05:00"
description: "The python feature installs a Python version with uv python install; it uses the uv of the dev user, or else the bootstrap uv."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:22-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/features/python.mdx"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/python/devcontainer-feature.json"
    title: "python devcontainer-feature.json"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/tree/main/src/python/ansible-role-feature"
    title: "python Ansible role"
---

# Feature: python

The `python` feature installs a Python version with `uv python install <version>`. It uses the uv in `~/.local/bin` if it exists, or else the bootstrap uv in `/usr/local/bin`. The role then asserts that the interpreter and the `python<version>` executable exist. uv downloads a standalone Python build. The role has no pinned checksum.

## Options

Feature version 1.7.2. The defaults are from `src/python/devcontainer-feature.json` on 2026-10-28.

| Option | Default | Use |
|---|---|---|
| `target_version` | `3.14` | The Python version, `X.Y`. |

## Dependencies

* `dependsOn`: `./bootstrap`. The runtime installs [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) first ([ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md)).
* `installsAfter`: `./uv-ruff`. This sets the order only. It does not install the other feature.

## Test templates

The test templates `ansible-cue`, `python` in `test-templates/` use this feature.

## Notes

* The docs page says that the feature uses the uv of the `uv-ruff` feature and depends on it. The code can use the bootstrap uv, and `uv-ruff` is only in `installsAfter`.

## Related

* [The python feature skipped the interpreter install after uv-ruff](/issues/the-python-feature-skipped-the-interpreter-install-after-uv-ruff--01a18382616d.md)
* [CPython 3.13 had CVE-2026-82049 with no fix on its line](/issues/cpython-3-13-had-cve-2026-82049-with-no-fix-on-its-line--01a183826199.md)
* [uv 0.12.5 installed CPython 3.14.7, which has two CVEs](/issues/uv-0-12-5-installed-cpython-3-14-7-which-has-two-cves--01a1838261cb.md)
* [Feature: uv-ruff](/features/feature-uv-ruff--01a183801130.md)
* [Feature: ansible-core](/features/feature-ansible-core--01a183800d2e.md) — orders after this feature.
* [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) — the fallback uv.
* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
