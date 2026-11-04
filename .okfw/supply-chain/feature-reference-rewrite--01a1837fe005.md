---
id: "01a1837f-e005-745c-a9b3-28831f2129f3"
title: "Feature reference rewrite"
type: "component"
tags:
  - "supply-chain"
  - "dependency"
  - "feature-refs"
created: "2026-10-28T12:12:38-05:00"
timestamp: "2026-10-28T12:20:33-05:00"
description: "rewrite-feature-refs.sh changes relative ./ references to ghcr.io references at publish time; --check validates them on each pull request."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:33-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/rewrite-feature-refs.sh"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/verify-published-refs.sh"
    title: "scripts/verify-published-refs.sh"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/2"
    title: "PR #2 (published feature refs)"
---

# Feature reference rewrite

`scripts/rewrite-feature-refs.sh` changes the relative feature references in `src/*/devcontainer-feature.json` to published `ghcr.io` references. The source keeps the relative form `./<id>`, so the test templates use the working tree. The release changes it at publish time. PR #2 added the script, after the first release published `"./bootstrap"` to the dependents.

## Modes

| Mode | Where | What it does |
|---|---|---|
| `--check` | `repo-gate` job, `make check-feature-refs` | Makes sure that each `./<id>` names a directory in `src/`. Changes nothing. |
| default | `stage-dependents` job | Changes each `./<id>` to `ghcr.io/<owner>/<repo>/<id>`. With `BOOTSTRAP_DIGEST`, adds `@<digest>` to the `bootstrap` reference in `dependsOn` only. |

## Checks on its own output (default mode)

1. No file in `src/*/devcontainer-feature.json` contains `"./`.
2. With `BOOTSTRAP_DIGEST`, each file that has `dependsOn` contains `ghcr.io/<repo>/bootstrap@<digest>`.

## Why `installsAfter` gets no digest

`installsAfter` only orders features that the consumer selected. The CLI matches it by id. A digest there could fail to match a consumer who pinned a different digest of the same feature.

## A second check in the registry

The [review step](/supply-chain/stage-review-and-promote-by-digest--01a1837fdf62.md) reads the staged metadata back from the registry and checks it again. A script that checks only its own output cannot prove what reached the registry. `scripts/verify-published-refs.sh` does a similar check on production, but no workflow or `make` target calls it (2026-10-28).

## Related

* [Published features had relative dependsOn references](/issues/published-features-had-relative-dependson-references--01a18382602b.md)
* [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md)
* [ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md)
* [Feature dependency model](/architecture/feature-dependency-model--01a1837fddea.md)
* [Release workflow](/supply-chain/release-workflow--01a1837fdeee.md)
* [Static checks](/supply-chain/static-checks--01a1837fe0c4.md)
* [Supply chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
