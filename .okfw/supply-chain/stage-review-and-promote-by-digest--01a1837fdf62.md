---
id: "01a1837f-df62-7289-b9b9-a56b63193abf"
title: "Stage, review and promote by digest"
type: "component"
tags:
  - "supply-chain"
  - "release"
  - "staging"
created: "2026-10-28T12:12:37-05:00"
timestamp: "2026-10-28T12:20:33-05:00"
description: "The release publishes to a staging namespace, signs a verdict that lists digests, then copies only those digests to production."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:33-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/.github/workflows/release.yaml"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/review-staged-features.sh"
    title: "scripts/review-staged-features.sh"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/sign-features.sh"
    title: "scripts/sign-features.sh"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/promote-features.sh"
    title: "scripts/promote-features.sh"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/13"
    title: "PR #13 (staged release with review)"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/23"
    title: "PR #23 (promote only reviewed tags)"
---

# Stage, review and promote by digest

The release does not publish directly to the production namespace. The Build-Actor stages, the Review-Actor reviews, and the Release-Actor promotes. The verdict is a list of digests, so the promoted bytes are the reviewed bytes. PR #13 introduced this model.

## Namespaces

| Namespace | Use |
|---|---|
| `ghcr.io/infrashift/trusted-devcontainer-features-staging/<id>` | Staging. Private by default. Consumers do not pull from it. |
| `ghcr.io/infrashift/trusted-devcontainer-features/<id>` | Production. Consumers pull from it. |

## Stage

1. `scripts/check-published-drift.sh --seed` copies unchanged production bytes into staging. See [Published drift check](/supply-chain/published-drift-check--01a1837fdf81.md).
2. `devcontainers/action` publishes the features to staging. It skips a version that exists.

## Review (`scripts/review-staged-features.sh`)

For each feature, the script reads `<staging>/<id>:latest`, gets the digest, and reads the `dev.containers.metadata` annotation by digest. Then it checks:

1. No `installsAfter` or `dependsOn` reference starts with `./`.
2. Each `dependsOn` key ends with `@sha256:<64 hex>`.
3. Each `dependsOn` names the production namespace. When `EXPECT_DEPENDS_ON` is set, each `dependsOn` is equal to it.

The script writes `staging-verdict.json`: `repository`, `staging_namespace`, `production_namespace`, `reviewed` and `features` (`feature`, `digest`). It fails when it reviewed zero features.

## Sign (`scripts/sign-features.sh`)

With `SIGN_NAMESPACE` set to staging, the script signs `<staging>/<id>@<digest>` two times: with the release key, and keyless. It writes `release-manifest.json`. It fails when it signed zero features. Signing occurs before promotion, since a keyless failure on 2026-09-16 left `sqlpackage` 1.0.2 unsigned in production.

## Promote (`scripts/promote-features.sh`)

1. Verify `staging-verdict.json.sig` against `review.pub`. If it fails, promote nothing.
2. Make sure that `production_namespace` in the verdict is the target namespace.
3. For each feature, make sure that staging `:latest` still has the reviewed digest.
4. Make sure that the signature tag `sha256-<digest>.sig` exists in staging.
5. Copy each staging tag that resolves to the reviewed digest. Copy the `.sig`, `.att` and `.sbom` tags tag-to-tag. Leave all other tags. PR #23 added this rule.
6. Make sure that production `:latest` has the reviewed digest.

`DRY_RUN=1` verifies and reports, and copies nothing.

## Related

* [The release published to production before a review](/issues/the-release-published-to-production-before-a-review--01a18382607e.md)
* [Promotion moved old version tags onto the newest build](/issues/promotion-moved-old-version-tags-onto-the-newest-build--01a1838260cd.md)
* [Promotion copied features to production before it signed them](/issues/promotion-copied-features-to-production-before-it-signed-them--01a1838260f4.md)
* [Old production version tags still point at newer builds](/issues/old-production-version-tags-still-point-at-newer-builds--01a1838264a1.md)
* [Release workflow](/supply-chain/release-workflow--01a1837fdeee.md)
* [Signing actors and keys](/supply-chain/signing-actors-and-keys--01a1837fdf43.md)
* [Feature dependency model](/architecture/feature-dependency-model--01a1837fddea.md)
* [Release and promote the features](/operations/release-and-promote-the-features--01a1837fe1e1.md)
* [Supply chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
