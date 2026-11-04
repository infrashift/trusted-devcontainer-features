---
id: "01a1837f-df43-7807-8458-ffcba2ede0d2"
title: "Signing actors and keys"
type: "component"
tags:
  - "supply-chain"
  - "signing"
  - "actors"
created: "2026-10-28T12:12:37-05:00"
timestamp: "2026-10-28T12:20:27-05:00"
description: "Three GitHub environments, Build-Actor, Review-Actor and Release-Actor, separate staging, the signed verdict and the signed promotion."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:27-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/SETUP-ENVIRONMENTS.md"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/.github/workflows/release.yaml"
    title: "release.yaml"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/.github/pdp/public-keys/release.pub"
    title: "release.pub"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/.github/pdp/public-keys/review.pub"
    title: "review.pub"
---

# Signing actors and keys

The release uses three signing actors. Each signing actor is a GitHub environment. Thus the job that publishes to staging cannot sign a verdict, and the job that signs a verdict cannot promote.

## The actors

| Signing actor | Secrets | Public key | Jobs in `release.yaml` | Signs |
|---|---|---|---|---|
| `Build-Actor` | none | none | `stage-bootstrap`, `stage-dependents` | nothing |
| `Review-Actor` | `COSIGN_PRIVATE_KEY`, `COSIGN_PASSWORD` | `review.pub` | `review-bootstrap`, `review-dependents` | `staging-verdict.json` |
| `Release-Actor` | `COSIGN_PRIVATE_KEY`, `COSIGN_PASSWORD` | `release.pub` | `promote-bootstrap`, `promote-dependents` | Each staged feature digest, keyed and keyless |

The public keys are in `.github/pdp/public-keys/`. `release.pub` came in `fa04742` (2026-08-23). `review.pub` came in `f444103` (2026-08-24). `cosign generate-key-pair` makes ECDSA P-256 keys.

## Chain of verification

1. The Review-Actor signs the verdict with the review key.
2. The Release-Actor verifies the verdict against the committed `review.pub`. It does not hold the review key, so it cannot make a verdict.
3. The Release-Actor signs each staged digest with the release key, and again keyless (Rekor).
4. A consumer verifies a feature against `release.pub`. See [Verify a published feature](/operations/verify-a-published-feature--01a1837fe2c1.md).

## Environment protection

Read with `gh api` on 2026-10-28:

| Environment | Rules | Branch policy |
|---|---|---|
| `Build-Actor` | none | none |
| `Review-Actor` | none | none |
| `Release-Actor` | `required_reviewers` (`ryancraig`), `branch_policy` | custom: branch `main` |
| `github-pages` | `branch_policy` | custom |

`prevent_self_review` is `false` on `Release-Actor`. The organization has one member, so "Prevent self-review" would block each release.

## What the separation gives

* A compromised build job can fill staging. It cannot make a verdict that the Release-Actor accepts.
* A compromised action in the `contract` job cannot sign, because that job has no environment.

## What it does not give

The organization has one member. An approval on `Release-Actor` is a self-approval: a stop before a release, not a separation of duties between two persons.

## Related

* [The pipeline published unsigned features with movable action tags](/issues/the-pipeline-published-unsigned-features-with-movable-action-tags--01a183826378.md)
* [CODEOWNERS and the human gate assume a multi-person org](/issues/codeowners-and-the-human-gate-assume-a-multi-person-org--01a183826510.md)
* [Stage, review and promote by digest](/supply-chain/stage-review-and-promote-by-digest--01a1837fdf62.md)
* [Release workflow](/supply-chain/release-workflow--01a1837fdeee.md)
* [Set up the GitHub environments and signing keys](/operations/set-up-the-github-environments-and-signing-keys--01a1837fe20a.md)
* [CODEOWNERS](/supply-chain/codeowners--01a1837fe0ed.md)
* [Supply chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
