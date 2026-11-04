---
id: "01a1837f-dfa2-7723-abde-67233777e9e7"
title: "Bootstrap fan-out check"
type: "component"
tags:
  - "supply-chain"
  - "fan-out"
  - "bootstrap"
created: "2026-10-28T12:12:38-05:00"
timestamp: "2026-10-28T12:20:33-05:00"
description: "check-bootstrap-fanout.sh fails when the bootstrap version changes but a dependent feature keeps its old version."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:33-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/check-bootstrap-fanout.sh"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/8"
    title: "PR #8 (pin dependsOn by digest)"
---

# Bootstrap fan-out check

`scripts/check-bootstrap-fanout.sh <base-ref>` enforces fan-out. When the `bootstrap` version changes, the version of each feature with `dependsOn` must also change in the same change.

## Why

Each dependent pins `bootstrap` by digest. The release publishes a feature only when its version changed. Thus a `bootstrap` bump alone publishes new `bootstrap` bytes that no dependent uses. The dependents keep the old digest, and the release reports success.

## How it works

1. Read the `bootstrap` version at `HEAD` and at `<base-ref>`.
2. When `bootstrap` has no version at the base, or the version did not change, pass.
3. For each feature in `src/` with `dependsOn` (not `bootstrap`, not `SKELETON-feature`), compare the version at `HEAD` and at the base.
4. Fail and list each dependent with the same version.
5. Fail when it found zero dependents.

## Where it runs

| Where | Base |
|---|---|
| `repo-gate` job | The base SHA of the pull request |
| `make check-fanout` | `BASE`, default `main` |

## Related

* [Feature dependsOn resolved bootstrap by tag, not by digest](/issues/feature-dependson-resolved-bootstrap-by-tag-not-by-digest--01a183826056.md)
* [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md)
* [ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md)
* [Change the bootstrap feature](/operations/change-the-bootstrap-feature--01a1837fe171.md)
* [Feature dependency model](/architecture/feature-dependency-model--01a1837fddea.md)
* [Published drift check](/supply-chain/published-drift-check--01a1837fdf81.md)
* [Static checks](/supply-chain/static-checks--01a1837fe0c4.md)
* [Supply chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
