---
id: "01a1837f-e20a-73e0-b138-450a58277860"
title: "Set up the GitHub environments and signing keys"
type: "runbook"
tags:
  - "runbook"
  - "signing"
  - "setup"
created: "2026-10-28T12:12:38-05:00"
timestamp: "2026-10-28T12:20:27-05:00"
description: "One-time setup of the three actor environments, the release and review keypairs and the main ruleset, as SETUP-ENVIRONMENTS.md gives it."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:27-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/SETUP-ENVIRONMENTS.md"
---

# Set up the GitHub environments and signing keys

`SETUP-ENVIRONMENTS.md` gives the one-time setup that a human must do before the release can run. It has the exact `gh`, `cosign` and `jq` commands. This runbook gives the order and the main warnings only. The setup is complete: the file records it as done on 2026-08-23 and 2026-08-24, and `gh api` confirmed the environments on 2026-10-28.

## Prerequisites

* `gh` with the scopes `admin:org`, `repo` and `write:packages`.
* `cosign` at the version in `tools.lock`, and `opa`.

## Procedure

1. Make a temporary directory in `/dev/shm`.

   WARNING: Do not make a key in a Git working tree.
2. Make the release keypair with `cosign generate-key-pair`. The key type is ECDSA P-256.
3. Copy `release.pub` to `.github/pdp/public-keys/release.pub` and commit it.
4. Create the `Release-Actor` environment. Set the secrets `COSIGN_PRIVATE_KEY` and `COSIGN_PASSWORD`.
5. Add `ryancraig` as the required reviewer of `Release-Actor`. Keep `prevent_self_review` at `false`.

   WARNING: The environment `PUT` endpoint replaces the environment. Always send `reviewers` and `prevent_self_review` with the branch policy.
6. Set a custom branch policy on `Release-Actor` that allows only the branch `main`.
7. Make a second keypair for review. Commit `review.pub` to `.github/pdp/public-keys/`.

   WARNING: Do not use the release key as the review key.
8. Create `Build-Actor` with no secrets. Create `Review-Actor` with the review `COSIGN_PRIVATE_KEY` and `COSIGN_PASSWORD`.
9. Create the `main` ruleset: pull request required, 0 approvals, no Code Owner review, required status check `repo-gate` only, no bypass actors.

   WARNING: Do not require `test/gate`. Its workflow has a path filter, so it does not report on every pull request.
10. Delete the private key files and the temporary directory.
11. Run `gh api repos/infrashift/trusted-devcontainer-features/environments --jq '.environments[].name'`. Expect the three actors and `github-pages`.
12. Run `make check`. Open a documentation-only pull request and make sure that `repo-gate` reports.

## Related

* [The main ruleset does not require test/gate](/issues/the-main-ruleset-does-not-require-test-gate--01a1838264d9.md)
* [CODEOWNERS and the human gate assume a multi-person org](/issues/codeowners-and-the-human-gate-assume-a-multi-person-org--01a183826510.md)
* [Signing actors and keys](/supply-chain/signing-actors-and-keys--01a1837fdf43.md)
* [CODEOWNERS](/supply-chain/codeowners--01a1837fe0ed.md) — what changes when a second maintainer joins.
* [Release workflow](/supply-chain/release-workflow--01a1837fdeee.md)
* [Operations overview](/operations/operations-overview--01a1837af719.md)
