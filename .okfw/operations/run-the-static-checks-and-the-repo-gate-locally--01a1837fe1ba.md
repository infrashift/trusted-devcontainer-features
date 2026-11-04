---
id: "01a1837f-e1ba-73b0-afde-b5ca2dffb5e7"
title: "Run the static checks and the repo gate locally"
type: "runbook"
tags:
  - "runbook"
  - "static-checks"
  - "pdp"
created: "2026-10-28T12:12:38-05:00"
timestamp: "2026-10-28T12:20:27-05:00"
description: "Install the pinned tools with make tools, then run make check before each push to run the repo-gate checks without containers."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:27-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/Makefile"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/repo-gate.sh"
    title: "scripts/repo-gate.sh"
---

# Run the static checks and the repo gate locally

Run `make check` before you push. It runs the [static checks](/supply-chain/static-checks--01a1837fe0c4.md) of the `repo-gate` job, including the [PDP](/supply-chain/policy-decision-point-pdp--01a1837fdf26.md), without a container build.

## Prerequisites

* `bash`, `git`, `jq`, `curl`, `python3` and `shellcheck`.
* Network access to `ghcr.io` for `check-published-drift`.

## Procedure

1. Run `BIN=~/.local/bin make tools`. It installs the pinned `opa` and `gitleaks`.
2. Run `make check`.
3. If a check fails, read its message and use the fix in the table below.
4. To run only the PDP, run `make repo-gate`. Then read `repo-decision.json`.
5. To see the version currency report, run `make check-currency`.

## Fixes

| Target | Fix when it fails |
|---|---|
| `check-contract` | Restore the rule that the message names. See [Role contract](/architecture/role-contract--01a1837fddd1.md). |
| `check-version-pins` | Change `ROLE_ARGS` or the test-template option to the declared default. |
| `check-fanout` | Bump each dependent. See [Change the bootstrap feature](/operations/change-the-bootstrap-feature--01a1837fe171.md). |
| `check-published-drift` | Bump the feature `version`. |
| `check-feature-refs` | Correct the `./<id>` reference. |
| `check-workflows` | Pin the action to a commit SHA with a version comment, or move the grant to the job. |
| `lint-shell` | Correct the `shellcheck` warning. |
| `check-policy` | Run `opa fmt -w .github/pdp/`, or add tests. |
| `repo-gate` | Read the violation codes. |

## Differences from CI

* CI also checks the size and content of `.gitleaks.toml` before the gate. `make check` does not.
* CI also runs `check-version-currency.sh`. `make check` does not.
* `make check-fanout` compares with `main`. CI compares with the base SHA of the pull request.
* CI clones the full history. A shallow local clone gives `gitleaks` fewer commits to scan.

## Related

* [Static checks](/supply-chain/static-checks--01a1837fe0c4.md)
* [PR Gate workflow](/supply-chain/pr-gate-workflow--01a1837fdeb7.md)
* [Pinned CI tools](/supply-chain/pinned-ci-tools--01a1837fe09c.md)
* [Operations overview](/operations/operations-overview--01a1837af719.md)
