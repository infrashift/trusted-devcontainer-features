---
id: "01a1837f-de9c-7680-b2a9-81b02bb1546c"
title: "Repository layout"
type: "component"
tags:
  - "architecture"
  - "layout"
created: "2026-10-28T12:12:37-05:00"
timestamp: "2026-10-28T12:20:27-05:00"
description: "The top-level directories and files of the features repository and what each one holds."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:27-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/README.md"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/.gitignore"
    title: ".gitignore"
---

# Repository layout

This concept lists the top-level parts of the `trusted-devcontainer-features` repository.

| Path | Holds |
|---|---|
| `src/<id>/` | One feature: `devcontainer-feature.json`, `install.sh`, `ansible-role-feature/`, and often `NOTES.md` and `README.md` |
| `src/bootstrap/` | The `bootstrap` feature: a plain bash `install.sh` and `assets/` (`run-feature.sh`, `site.yml`, `tasks/install-packages.yml`) |
| `test-templates/<name>/` | One test template: `.devcontainer/devcontainer.json` and `tests.sh` |
| `test-templates/shared/` | `Containerfile`, `contract-tests.sh`, `test-lib.sh` |
| `scripts/` | The static checks and the release scripts |
| `.github/workflows/` | `pr-gate.yml`, `test-templates.yaml`, `release.yaml`, `deploy-docs.yaml` |
| `.github/pdp/` | `policies.rego`, `policies_test.rego` and `public-keys/` (`release.pub`, `review.pub`) |
| `.github/CODEOWNERS` | Reviewer assignment |
| `.devcontainer/` | The maintainer dev container and `SKELETON-feature/` |
| `docs/` | The Astro Starlight documentation site: ADRs, feature pages, reference pages |
| `tools.lock` | Pinned CI tool versions |
| `.gitleaks.toml` | The secret-scanning config |
| `Makefile` | The local entry points: `make help` lists them |
| `SETUP-ENVIRONMENTS.md` | One-time GitHub setup |
| `.okfw/` | This wiki |

## The feature directory

```
src/<id>/
├── devcontainer-feature.json    metadata, options with defaults, dependsOn, installsAfter
├── install.sh                   the thin wrapper
└── ansible-role-feature/
    ├── defaults/main.yml        empty (role contract)
    ├── vars/main.yml            compatibility list, pinned checksums, derived values
    ├── meta/main.yml
    └── tasks/main.yml           asserts, installation, version check
```

No feature has a `hosts.yml` or `activate-feature.yml`. The `bootstrap` feature writes the inventory, and `site.yml` is shared.

## Generated files

These files are in `.gitignore`: the feature copies in `test-templates/*/.devcontainer/*/` and `.devcontainer/*/` (except `SKELETON-feature/`), `repo-decision.json` and `release-manifest.json`.

## Related

* [Feature install pipeline](/architecture/feature-install-pipeline--01a1837fdd88.md)
* [Role contract](/architecture/role-contract--01a1837fddd1.md)
* [Test templates](/architecture/test-templates--01a1837fde68.md)
* [Static checks](/supply-chain/static-checks--01a1837fe0c4.md)
* [Architecture overview](/architecture/architecture-overview--01a1837af69f.md)
