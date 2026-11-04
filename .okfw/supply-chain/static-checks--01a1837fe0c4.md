---
id: "01a1837f-e0c4-7e1c-b6bd-b6c1756bfaae"
title: "Static checks"
type: "component"
tags:
  - "supply-chain"
  - "static-checks"
  - "make"
created: "2026-10-28T12:12:38-05:00"
timestamp: "2026-10-28T12:20:27-05:00"
description: "The table of every static check: its script, its make target, and where CI runs it."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:27-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/Makefile"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/.github/workflows/pr-gate.yml"
    title: "pr-gate.yml"
---

# Static checks

The static checks run without a container build. The `repo-gate` job of the [PR Gate workflow](/supply-chain/pr-gate-workflow--01a1837fdeb7.md) runs them on each pull request. `make check` runs most of them locally.

## The checks

| Check | Script or command | `make` target | In `make check` | In `repo-gate` | Blocks |
|---|---|---|---|---|---|
| [Role contract](/architecture/role-contract--01a1837fddd1.md) | `scripts/check-role-contract.sh` | `check-contract` | yes | yes | yes |
| [Version pins](/supply-chain/version-pins-check--01a1837fdfc3.md) | `scripts/check-version-pins.sh` | `check-version-pins` | yes | yes | yes |
| [Version currency](/supply-chain/version-currency-check--01a1837fdfe4.md) | `scripts/check-version-currency.sh` | `check-currency` | no | yes | no (warns) |
| [Bootstrap fan-out](/supply-chain/bootstrap-fan-out-check--01a1837fdfa2.md) | `scripts/check-bootstrap-fanout.sh` | `check-fanout` | yes | yes | yes |
| [Published drift](/supply-chain/published-drift-check--01a1837fdf81.md) | `scripts/check-published-drift.sh --check` | `check-published-drift` | yes | yes | yes |
| [Feature references](/supply-chain/feature-reference-rewrite--01a1837fe005.md) | `scripts/rewrite-feature-refs.sh --check` | `check-feature-refs` | yes | yes | yes |
| [Single policy](/supply-chain/single-policy-check--01a1837fe04c.md) | `scripts/check-no-orphan-rego.sh` | part of `check-policy` | yes | yes | yes |
| [Workflow lint](/supply-chain/workflow-lint--01a1837fe026.md) | `scripts/lint-workflows.sh` | `check-workflows` | yes | yes | yes |
| Shell lint | `shellcheck -S warning scripts/*.sh` | `lint-shell` | yes | yes | yes |
| Policy self-test | `opa check --strict`, `opa fmt --list`, `opa test`, coverage 85% | `check-policy` | yes | yes | yes |
| Gitleaks config guard | `stat` and `grep` on `.gitleaks.toml` | none | no | yes | yes |
| [Repo gate](/supply-chain/policy-decision-point-pdp--01a1837fdf26.md) | `scripts/repo-gate.sh` | `repo-gate` | yes | yes | yes |

The `contract` job of `release.yaml` runs the role contract check again before each release.

## Tools that the checks need

`bash`, `jq`, `curl`, `git`, `python3`, `shellcheck`, and the pinned `opa` and `gitleaks`. `check-published-drift` also needs network access to `ghcr.io`. `check-currency` needs network access to the upstreams.

## Related

* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md)
* [Run the static checks and the repo gate locally](/operations/run-the-static-checks-and-the-repo-gate-locally--01a1837fe1ba.md)
* [PR Gate workflow](/supply-chain/pr-gate-workflow--01a1837fdeb7.md)
* [Policy decision point (PDP)](/supply-chain/policy-decision-point-pdp--01a1837fdf26.md)
* [Supply chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
