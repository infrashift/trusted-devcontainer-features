---
id: "01a1837f-deee-719f-8e7b-e92bfa5e9e1c"
title: "Release workflow"
type: "workflow"
tags:
  - "supply-chain"
  - "workflow"
  - "release"
created: "2026-10-28T12:12:37-05:00"
timestamp: "2026-10-28T12:20:27-05:00"
description: "release.yaml runs on each push to main: role contract, then stage, review and promote for bootstrap, then for the dependents."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:27-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/.github/workflows/release.yaml"
---

# Release workflow

The `Release Dev Container Features` workflow (`.github/workflows/release.yaml`) runs on each push to `main`. It stages, reviews and promotes `bootstrap` first, then the other features. See [Stage, review and promote by digest](/supply-chain/stage-review-and-promote-by-digest--01a1837fdf62.md) for the model.

## Trigger

* `push` to `main`. No path filter.
* Concurrency group `release`, with `cancel-in-progress: false`. A release in progress is never cancelled.
* `STAGING_NAMESPACE` is `<owner>/<repo>-staging`, a separate GHCR namespace.

## Jobs

| Job | Environment | What it does |
|---|---|---|
| `contract` (`role contract`) | none | Runs `check-role-contract.sh`. Makes sure that `review.pub` exists. Computes the feature list and the dependents list. |
| `stage-bootstrap` | `Build-Actor` | Runs `check-published-drift.sh --seed`, then publishes `bootstrap` to staging with `devcontainers/action`. |
| `review-bootstrap` | `Review-Actor` | Runs `review-staged-features.sh`. Signs `staging-verdict.json` with the review key. |
| `promote-bootstrap` | `Release-Actor` | Runs `sign-features.sh` on staging, then `promote-features.sh`. Reads the production `bootstrap` digest. |
| `stage-dependents` | `Build-Actor` | Runs `rewrite-feature-refs.sh` with the production `bootstrap` digest, `--seed`, then publishes all other features to staging. |
| `review-dependents` | `Review-Actor` | Reviews with `EXPECT_DEPENDS_ON=ghcr.io/<repo>/bootstrap@<digest>`. Signs the verdict. |
| `promote-dependents` | `Release-Actor` | Signs staging, promotes, uploads `release-manifest.json`. |
| `summary` | none | Writes a table of seven rows. Fails when a job did not succeed or skip. |

## Notes

* Staging does not create Git tags (`disable-repo-tagging: "true"`).
* Each promote job has `id-token: write` for the keyless cosign signature.
* The `devcontainers/action` publish skips a version that exists in staging. Thus a source change needs a version bump. See [Published drift check](/supply-chain/published-drift-check--01a1837fdf81.md).

## Required status

None. This workflow runs after the merge. A human approves each `Release-Actor` job.

## Related

* [The release published to production before a review](/issues/the-release-published-to-production-before-a-review--01a18382607e.md)
* [Promotion copied features to production before it signed them](/issues/promotion-copied-features-to-production-before-it-signed-them--01a1838260f4.md)
* [Promotion moved old version tags onto the newest build](/issues/promotion-moved-old-version-tags-onto-the-newest-build--01a1838260cd.md)
* [Old production version tags still point at newer builds](/issues/old-production-version-tags-still-point-at-newer-builds--01a1838264a1.md)
* [Code comments give old counts and names](/issues/code-comments-give-old-counts-and-names--01a183894c99.md)
* [Signing actors and keys](/supply-chain/signing-actors-and-keys--01a1837fdf43.md)
* [Feature dependency model](/architecture/feature-dependency-model--01a1837fddea.md)
* [Feature reference rewrite](/supply-chain/feature-reference-rewrite--01a1837fe005.md)
* [Release and promote the features](/operations/release-and-promote-the-features--01a1837fe1e1.md)
* [Supply chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
