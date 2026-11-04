---
id: "01a1837f-ded2-7c89-b16d-fb262cd96714"
title: "Test Features in Templates workflow"
type: "workflow"
tags:
  - "supply-chain"
  - "workflow"
  - "testing"
created: "2026-10-28T12:12:37-05:00"
timestamp: "2026-10-28T12:20:33-05:00"
description: "test-templates.yaml builds the affected test templates on amd64 and arm64 and reports one aggregate test/gate check."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:33-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/.github/workflows/test-templates.yaml"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/compute-test-matrix.sh"
    title: "scripts/compute-test-matrix.sh"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/SETUP-ENVIRONMENTS.md"
    title: "SETUP-ENVIRONMENTS.md step 5"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/10"
    title: "PR #10 (arm64 coverage)"
---

# Test Features in Templates workflow

The `Test Features in Templates` workflow (`.github/workflows/test-templates.yaml`) builds the [test templates](/architecture/test-templates--01a1837fde68.md) that a change can affect. It runs the smoke tests and the contract tests on native amd64 and arm64 runners. It reports one aggregate check, `test/gate`.

## Trigger

`push` and `pull_request` to `main`, only when one of these paths changes: `src/**`, `test-templates/**`, `scripts/**`, `tools.lock`, `.github/workflows/test-templates.yaml`.

## Jobs

| Job | What it does |
|---|---|
| `matrix-setup` (`Compute Matrix`) | Runs `scripts/compute-test-matrix.sh`. On a pull request it diffs against the base SHA. On a push it uses `--all`. |
| `test` (`template (<name>, <arch>)`) | For each matrix entry: installs the pinned devcontainer CLI, copies `src/*` into the template, runs `devcontainer up`, `tests.sh` and `contract-tests.sh`. |
| `gate` (`test/gate`) | Fails when `matrix-setup` failed, or when `test` did not succeed. A skipped `test` passes only when the matrix is empty. |

## How the matrix is computed

* A change to `src/bootstrap/`, `test-templates/shared/`, `scripts/`, `tools.lock` or the workflow selects all templates.
* A change to `src/<id>/` selects each template whose `devcontainer.json` lists that feature.
* A change in `test-templates/<name>/` selects that template.
* Each selected template has two entries: `amd64` on `ubuntu-latest` and `arm64` on `ubuntu-24.04-arm`.
* When the script cannot diff, it selects all templates.

## Signing actor

None.

## Required status

`test/gate` is not a required check (2026-10-28). The workflow has a path filter. Thus on a pull request that changes no test path, `test/gate` does not report, and a required `test/gate` would block the merge. `SETUP-ENVIRONMENTS.md` step 5 records this.

Do not make a matrix leg a required check. The job names change with the matrix.

## Related

* [Test templates](/architecture/test-templates--01a1837fde68.md)
* [Contract tests](/architecture/contract-tests--01a1837fde81.md)
* [PR Gate workflow](/supply-chain/pr-gate-workflow--01a1837fdeb7.md)
* [Test one template locally](/operations/test-one-template-locally--01a1837fe195.md)
* [Supply chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
