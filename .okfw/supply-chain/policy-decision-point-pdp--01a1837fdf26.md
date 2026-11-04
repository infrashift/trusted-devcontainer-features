---
id: "01a1837f-df26-76bb-be04-ac02374d3e2d"
title: "Policy decision point (PDP)"
type: "component"
tags:
  - "supply-chain"
  - "pdp"
  - "opa"
created: "2026-10-28T12:12:37-05:00"
timestamp: "2026-10-28T12:20:27-05:00"
description: "The OPA policy .github/pdp/policies.rego has one entry point, repo_decision, for secret scanning and tool and action pinning."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:27-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/.github/pdp/policies.rego"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/repo-gate.sh"
    title: "scripts/repo-gate.sh"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/.github/pdp/policies_test.rego"
    title: "policies_test.rego"
---

# Policy decision point (PDP)

The PDP is the OPA policy `.github/pdp/policies.rego`, package `tdf.pdp`. It has one entry point, `data.tdf.pdp.repo_decision`. It decides on secret scanning, tool pinning and action pinning. It has no CVE gate: this repository publishes features, not images, and the CVE gate is in `trusted-devcontainer-templates`.

## Input

`scripts/repo-gate.sh` builds the input from measured facts, never from literal values:

| Field | Source |
|---|---|
| `evaluated_at` | `EVALUATED_AT`, or the current UTC time |
| `gitleaks.status` | `ran`, `error` or `not-installed` |
| `gitleaks.findings` | The JSON report of `gitleaks detect --exit-code 0` |
| `gitleaks.config_bytes` | `stat -c%s .gitleaks.toml` |
| `gitleaks.uses_default_ruleset` | `true` when `.gitleaks.toml` sets `useDefault = true` |
| `tools` | The `KEY=value` lines of `tools.lock` |
| `unpinned_actions` | Each `uses:` in `.github/workflows/` without a 40-hex SHA |

## Violations

| Code | When |
|---|---|
| `INPUT_TIMESTAMP_INVALID` | `evaluated_at` is missing or not RFC 3339 |
| `GITLEAKS_DID_NOT_RUN` | `gitleaks.status` is not `ran` |
| `GITLEAKS_REPORT_MALFORMED` | `findings` is not an array |
| `GITLEAKS_CONFIG_UNKNOWN` | `config_bytes` is not a number |
| `GITLEAKS_CONFIG_EMPTY` | `config_bytes` is less than 64 |
| `GITLEAKS_DEFAULTS_DISABLED` | `uses_default_ruleset` is not `true` |
| `SECRET_DETECTED` | One violation for each finding |
| `TOOLS_LOCK_MISSING` | `tools` is not an object |
| `TOOL_NOT_PINNED` | A `tools.lock` value does not start with `X.Y.Z` |
| `ACTION_NOT_PINNED` | One violation for each unpinned action |

The decision is `{allow, counts, evaluated_at, violations, warnings}`. `allow` is `true` only when there are no violations. No rule makes a warning yet. When the policy does not evaluate, the default decision denies.

## Design rules

* The policy does not call `time.now_ns()`. The same input gives the same decision.
* Each numeric field has an `is_number()` guard. Each enum uses `object.get()` with a `"<missing>"` value.
* Partial sets use `contains`, so a clean result is `[]`, not `{}`.

## Tests

`policies_test.rego` has 14 tests. `opa test` must give 85% coverage or more. See [Static checks](/supply-chain/static-checks--01a1837fe0c4.md).

## Related

* [Unused script and unused policy rules](/issues/unused-script-and-unused-policy-rules--01a183894cce.md)
* [PR Gate workflow](/supply-chain/pr-gate-workflow--01a1837fdeb7.md)
* [Secret scanning](/supply-chain/secret-scanning--01a1837fe074.md)
* [Pinned CI tools](/supply-chain/pinned-ci-tools--01a1837fe09c.md)
* [Single policy check](/supply-chain/single-policy-check--01a1837fe04c.md)
* [Run the static checks and the repo gate locally](/operations/run-the-static-checks-and-the-repo-gate-locally--01a1837fe1ba.md)
* [Supply chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
