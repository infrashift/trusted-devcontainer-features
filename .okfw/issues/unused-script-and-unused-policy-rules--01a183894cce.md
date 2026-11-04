---
id: "01a18389-4cce-7818-b458-70bebec13369"
title: "Unused script and unused policy rules"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "open"
  - "supply-chain"
  - "pdp"
created: "2026-10-28T12:22:55-05:00"
timestamp: "2026-10-28T12:24:37-05:00"
description: "No workflow or make target calls scripts/verify-published-refs.sh, and no rule uses severities or fix_states in policies.rego."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:24:37-05:00"
status: "draft"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/.github/pdp/policies.rego"
    title: "policies.rego"
---

# Unused script and unused policy rules

One script and two policy values are not used. Unused code in the supply-chain path looks like a check that runs, but it does not run.

## Problem

* No workflow and no `make` target calls `scripts/verify-published-refs.sh`.
* `.github/pdp/policies.rego` line 42 defines `severities` and line 44 defines `fix_states`. No rule in the policy uses them.

## Context

`release.yaml` does the post-promotion checks with other scripts. The two policy values are probably left from a CVE gate, as in the templates repository. This repository's PDP has only `repo_decision`.

## Acceptance criteria

- [ ] `verify-published-refs.sh` runs in a workflow or a `make` target, or it is removed.
- [ ] `severities` and `fix_states` are used, or they are removed, and `make check-policy` passes.

## Related

* [Policy decision point (PDP)](/supply-chain/policy-decision-point-pdp--01a1837fdf26.md)
* [Static checks](/supply-chain/static-checks--01a1837fe0c4.md)
* [Release workflow](/supply-chain/release-workflow--01a1837fdeee.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
