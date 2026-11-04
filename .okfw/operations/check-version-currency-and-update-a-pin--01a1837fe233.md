---
id: "01a1837f-e233-756c-8308-4fc4a00b7373"
title: "Check version currency and update a pin"
type: "runbook"
tags:
  - "runbook"
  - "version-currency"
  - "pin"
created: "2026-10-28T12:12:38-05:00"
timestamp: "2026-10-28T12:20:27-05:00"
description: "Run make check-currency, then update each behind pin with its checksums, ROLE_ARGS and test-template values and a version bump."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:27-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/check-version-currency.sh"
---

# Check version currency and update a pin

Use this procedure to find tools that are behind upstream and to update them. The [Version currency check](/supply-chain/version-currency-check--01a1837fdfe4.md) only warns, so a person must act on it.

## Procedure

1. Run `make check-currency`. You can also read the `Tool version currency` summary of the last `PR Gate` run.
2. For each `unknown` row, run the check again. A network failure gives `unknown`.
3. For each `behind` row, read the upstream release notes.

   WARNING: `nodejs`, `dotnet` and `openjdk` compare within the declared major line. `pnpm` stays on 10.x by choice. Do not change a major line in a currency update.
4. Download the new release for `amd64` and `arm64`. Calculate the checksums from the files.
5. Compare the checksums with the checksums that upstream publishes.
6. Update the feature with [Change a feature and bump its version](/operations/change-a-feature-and-bump-its-version--01a1837fe143.md).

   WARNING: If the tool is uv, Python or ansible-core in `bootstrap`, use [Change the bootstrap feature](/operations/change-the-bootstrap-feature--01a1837fe171.md).
7. Run `make check-currency` again. The row must show `current`.
8. Record the dated result as a finding.

## Related

* [On 2026-10-28, kaniko is the only feature pin behind upstream](/findings/on-2026-10-28-kaniko-is-the-only-feature-pin-behind-upstream--01a1838267fd.md)
* [The currency check skips the bootstrap, ruff and sqlpackage pins](/issues/the-currency-check-skips-the-bootstrap-ruff-and-sqlpackage-pins--01a183826696.md)
* [Version currency check](/supply-chain/version-currency-check--01a1837fdfe4.md)
* [Version pins check](/supply-chain/version-pins-check--01a1837fdfc3.md)
* [Findings overview](/findings/findings-overview--01a1837af700.md)
* [Operations overview](/operations/operations-overview--01a1837af719.md)
