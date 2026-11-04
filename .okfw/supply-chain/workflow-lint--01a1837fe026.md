---
id: "01a1837f-e026-7798-af0d-ea30d3181d57"
title: "Workflow lint"
type: "component"
tags:
  - "supply-chain"
  - "workflow-lint"
created: "2026-10-28T12:12:38-05:00"
timestamp: "2026-10-28T12:20:27-05:00"
description: "lint-workflows.sh checks action SHA pins, version comments, permissions, status context names, the PR gate path filter and untrusted interpolation."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:27-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/lint-workflows.sh"
---

# Workflow lint

`scripts/lint-workflows.sh` checks the files in `.github/workflows/`. Each rule finds a failure that a reviewer cannot see in a diff. It runs in the `repo-gate` job and as `make check-workflows`.

## Rules

1. Each `uses:` is pinned to a 40-hex commit SHA. A local action (`./...`) is exempt.
2. Each pinned `uses:` has a version comment, for example `# v5`.
3. The workflow-level `permissions:` block grants no `write`. Put each grant on the job that needs it.
4. All `-f context="..."` strings are identical. A seeded status with a different name stays pending.
5. `pr-gate.yml` has no `paths:` filter.
6. No `${{ github.event.* }}` value that an attacker controls (title, body, head ref, comment body) is in a workflow. Pass it through `env:`.

## Relation to the PDP

The [PDP](/supply-chain/policy-decision-point-pdp--01a1837fdf26.md) also denies an unpinned action (`ACTION_NOT_PINNED`). `scripts/repo-gate.sh` finds the unpinned actions with its own `grep`.

## Related

* [PR Gate workflow](/supply-chain/pr-gate-workflow--01a1837fdeb7.md)
* [Pinned CI tools](/supply-chain/pinned-ci-tools--01a1837fe09c.md)
* [Static checks](/supply-chain/static-checks--01a1837fe0c4.md)
* [Supply chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
