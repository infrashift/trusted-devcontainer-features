---
id: "01a1837f-deb7-7cf2-a42f-5fd0ae1f77c8"
title: "PR Gate workflow"
type: "workflow"
tags:
  - "supply-chain"
  - "workflow"
  - "pr-gate"
created: "2026-10-28T12:12:37-05:00"
timestamp: "2026-10-28T12:20:27-05:00"
description: "pr-gate.yml runs on every pull request to main, with no path filter, and publishes the required repo-gate check."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:27-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/.github/workflows/pr-gate.yml"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/repo-gate.sh"
    title: "scripts/repo-gate.sh"
---

# PR Gate workflow

The `PR Gate` workflow (`.github/workflows/pr-gate.yml`) runs on every pull request to `main`. It has no `paths:` filter, so its required check reports also on a pull request that changes only documentation. `scripts/lint-workflows.sh` fails when somebody adds a filter.

## Trigger

* `pull_request` to `main`.
* Concurrency group `pr-gate-<PR number>`, with `cancel-in-progress: true`.

## Job

| Job | Environment | Permissions | Output |
|---|---|---|---|
| `repo-gate` | none | `contents: read` | The `repo-gate` check and the `repo-decision` artifact |

## Steps of `repo-gate`

1. Check out with `fetch-depth: 0`, because `gitleaks` scans the full history.
2. Install the pinned `opa` and `gitleaks` with `scripts/install-tools.sh`.
3. Make sure that `.gitleaks.toml` has 64 bytes or more and sets `useDefault = true`.
4. Run `scripts/check-role-contract.sh`.
5. Run `scripts/check-version-pins.sh`.
6. Run `scripts/check-version-currency.sh`. It warns only.
7. Run `scripts/check-bootstrap-fanout.sh` against the base SHA of the pull request.
8. Run `scripts/check-published-drift.sh --check`.
9. Run `scripts/rewrite-feature-refs.sh --check`.
10. Run `scripts/check-no-orphan-rego.sh`.
11. Run `scripts/lint-workflows.sh`.
12. Run `shellcheck -S warning scripts/*.sh`.
13. Run `opa check --strict`, `opa fmt --list` and `opa test` on `.github/pdp/`. The coverage floor is 85%.
14. Run `scripts/repo-gate.sh repo-decision.json`. It evaluates `data.tdf.pdp.repo_decision`.
15. Write a summary and upload `repo-decision.json`, also after a failure.

## Signing actor

None. This workflow does not sign.

## Required status

`repo-gate` is the only required status check of the `main` ruleset (verified with `gh api` on 2026-10-28).

## Related

* [The main ruleset does not require test/gate](/issues/the-main-ruleset-does-not-require-test-gate--01a1838264d9.md)
* [Static checks](/supply-chain/static-checks--01a1837fe0c4.md) — one row for each step.
* [Policy decision point (PDP)](/supply-chain/policy-decision-point-pdp--01a1837fdf26.md)
* [Secret scanning](/supply-chain/secret-scanning--01a1837fe074.md)
* [Run the static checks and the repo gate locally](/operations/run-the-static-checks-and-the-repo-gate-locally--01a1837fe1ba.md)
* [Supply chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
