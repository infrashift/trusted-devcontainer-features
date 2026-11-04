---
id: "01a1837f-e171-73ac-8850-a1b33db84fa8"
title: "Change the bootstrap feature"
type: "runbook"
tags:
  - "runbook"
  - "bootstrap"
  - "fan-out"
created: "2026-10-28T12:12:38-05:00"
timestamp: "2026-10-28T12:20:27-05:00"
description: "A bootstrap change needs a new bootstrap version and a new version for every dependent feature in the same pull request."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:27-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/check-bootstrap-fanout.sh"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/24"
    title: "PR #24 (bootstrap uv bump and fan-out)"
---

# Change the bootstrap feature

A change to `src/bootstrap/` needs a new `bootstrap` version and a new version for each dependent feature, in the same pull request. Each dependent pins `bootstrap` by digest. A dependent that keeps its version keeps the old `bootstrap` digest. The [Bootstrap fan-out check](/supply-chain/bootstrap-fan-out-check--01a1837fdfa2.md) enforces this rule.

## Procedure

1. Change the files in `src/bootstrap/`.
2. Increase `version` in `src/bootstrap/devcontainer-feature.json`.
3. Increase the patch `version` of each other feature in `src/` that has `dependsOn`. On 2026-10-28, this is 26 features.
4. If you changed the uv default, change the two `PINNED_SHA256` entries in `src/bootstrap/install.sh`.
5. If you changed a default, change it in `docs/src/data/features.json` and in each test-template option.
6. Run `make check-fanout`.

   WARNING: `make check-fanout` compares with `main` by default. Run `BASE=<ref> make check-fanout` to compare with a different ref.
7. Run `make check`.
8. Run `make test` or test each template with `make test-template` and `make test-contract`. A `bootstrap` change affects all templates.
9. Open a pull request. CI builds all templates on both architectures.

## Result

The release promotes the new `bootstrap`, then publishes each dependent with the new `bootstrap` digest in `dependsOn`. PR #24 is an example: it changed uv in `bootstrap` and bumped all 26 dependents.

## Related

* [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md)
* [Bootstrap environment](/architecture/bootstrap-environment--01a1837fdda1.md)
* [Feature dependency model](/architecture/feature-dependency-model--01a1837fddea.md)
* [Change a feature and bump its version](/operations/change-a-feature-and-bump-its-version--01a1837fe143.md)
* [Release workflow](/supply-chain/release-workflow--01a1837fdeee.md)
* [Operations overview](/operations/operations-overview--01a1837af719.md)
