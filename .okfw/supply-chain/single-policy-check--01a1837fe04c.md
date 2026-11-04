---
id: "01a1837f-e04c-7b70-904e-ee05f3ce6d7b"
title: "Single policy check"
type: "component"
tags:
  - "supply-chain"
  - "pdp"
  - "opa"
created: "2026-10-28T12:12:38-05:00"
timestamp: "2026-10-28T12:20:27-05:00"
description: "check-no-orphan-rego.sh fails when a .rego file exists outside .github/pdp or the policy declares a package other than tdf.pdp."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:27-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/check-no-orphan-rego.sh"
---

# Single policy check

`scripts/check-no-orphan-rego.sh` makes sure that the repository has one policy only. It runs in the `repo-gate` job and first in `make check-policy`.

## Rules

1. No `.rego` file exists outside `.github/pdp/`. The script ignores `.git/` and `docs/node_modules/`.
2. `.github/pdp/` holds only `policies.rego` and `policies_test.rego`.
3. `policies.rego` declares exactly one package, and it is `tdf.pdp`.

## Why

A sibling repository had six `.rego` files that nothing evaluated. They disagreed with the live policy. A reader could not tell which policy decided.

## Related

* [Policy decision point (PDP)](/supply-chain/policy-decision-point-pdp--01a1837fdf26.md)
* [Static checks](/supply-chain/static-checks--01a1837fe0c4.md)
* [Supply chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
