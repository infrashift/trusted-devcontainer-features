---
id: "01a18382-602b-7daa-a9cc-eca52ced1a3e"
title: "Published features had relative dependsOn references"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "resolved"
  - "release"
  - "bootstrap"
created: "2026-10-28T12:15:22-05:00"
timestamp: "2026-10-28T12:20:56-05:00"
description: "The first release published ./bootstrap references that resolve in the consumer's folder; PR #2 rewrites them to registry references at publish time."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:56-05:00"
status: "deprecated"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/2"
    title: "PR #2"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/rewrite-feature-refs.sh"
---

# Published features had relative dependsOn references

The first release published the 19 dependent features with relative references such as `"./bootstrap"`. A consumer could not install them.

## Problem

Each `devcontainer-feature.json` declares `dependsOn` and `installsAfter` with relative paths, for example `"./bootstrap"`. These paths are correct in this repository, because the test templates copy `src/*` into `.devcontainer/`. In a published feature, the CLI resolves the path against the consumer's `.devcontainer/` folder. A template that pulled `python` failed with `ENOENT: .../src/python/.devcontainer/bootstrap/devcontainer-feature.json`.

## Context

* All tests stage the features locally, so `./bootstrap` always resolved. CI stayed green.
* The templates repository found the defect when it pulled `python:latest` (1.2.0) on 2026-08-24.

## Acceptance criteria

- [x] The release rewrites relative references to registry references before it publishes.
- [x] A check reads the published metadata back from the registry and fails on a relative reference.

## Resolution

* Date: 2026-08-24. PR #2 (merge `6e8b650`).
* `scripts/rewrite-feature-refs.sh` rewrites the references at publish time. Its `--check` mode runs in `pr-gate` and `make check`.
* `scripts/verify-published-refs.sh` reads the published artifact and fails the release before signing if a relative reference stays.
* The 19 dependents moved to version 1.2.1. `bootstrap` stayed at 1.1.0, because it has no dependencies.

## Related

* [ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md)
* [Feature reference rewrite](/supply-chain/feature-reference-rewrite--01a1837fe005.md)
* [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md)
* [Feature dependsOn resolved bootstrap by tag, not by digest](/issues/feature-dependson-resolved-bootstrap-by-tag-not-by-digest--01a183826056.md)
* [Supply-chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
