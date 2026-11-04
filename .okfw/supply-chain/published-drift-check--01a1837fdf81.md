---
id: "01a1837f-df81-7d58-98b9-fa3bb6c8f0ed"
title: "Published drift check"
type: "component"
tags:
  - "supply-chain"
  - "published-drift"
created: "2026-10-28T12:12:38-05:00"
timestamp: "2026-10-28T12:20:33-05:00"
description: "check-published-drift.sh compares each feature source with the bytes published at its version; --seed copies unchanged bytes into staging."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:33-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/check-published-drift.sh"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/15"
    title: "PR #15 (published content gate)"
---

# Published drift check

`scripts/check-published-drift.sh` finds published drift: source that is different from the bytes published at the same version. `devcontainer features publish` skips a version that exists. Thus without this check, a source change without a version bump is lost, and the release reports success. PR #15 added the check.

## Modes

| Mode | Where | When production has `:<version>` and it is identical | When it is different |
|---|---|---|---|
| `--check` (default) | `repo-gate` job, `make check-published-drift` | Report `unchanged` | Error: bump the version |
| `--seed` | `stage-bootstrap`, `stage-dependents` | Copy the production digest into staging under each production tag of that digest | Error |

When production has no tag for the version, the feature is `new` and the check passes.

## How it compares

1. Read `version` from `devcontainer-feature.json`.
2. Get the production digest of `<id>:<version>` with an anonymous pull token.
3. Extract the published tarball.
4. In `--check` mode, change `./bootstrap` in a copy of the source to the `bootstrap` digest that the published artifact names. Change other `./<id>` references to the bare production reference.
5. Run `diff -r` on the copy and the published files.

## Why `--seed`

The feature tarball is not byte-reproducible. On 2026-09-10, the first release into an empty staging namespace published unchanged `bootstrap` source under a new digest. All dependents then pinned the new digest, and consumers held two `bootstrap` features. `--seed` keeps the digest of unchanged source.

## Requirements

* Network access to `ghcr.io`.
* `python3`, `jq` and `curl`. `--seed` also needs `crane` and a login that can push to staging.

## Related

* [An unchanged feature got a new digest on each staged release](/issues/an-unchanged-feature-got-a-new-digest-on-each-staged-release--01a1838260a7.md)
* [Change a feature and bump its version](/operations/change-a-feature-and-bump-its-version--01a1837fe143.md)
* [Stage, review and promote by digest](/supply-chain/stage-review-and-promote-by-digest--01a1837fdf62.md)
* [Bootstrap fan-out check](/supply-chain/bootstrap-fan-out-check--01a1837fdfa2.md)
* [Static checks](/supply-chain/static-checks--01a1837fe0c4.md)
* [Supply chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
