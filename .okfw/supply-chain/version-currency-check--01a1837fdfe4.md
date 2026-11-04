---
id: "01a1837f-dfe4-76e0-aae9-6f5ef591223d"
title: "Version currency check"
type: "component"
tags:
  - "supply-chain"
  - "version-currency"
created: "2026-10-28T12:12:38-05:00"
timestamp: "2026-10-28T12:20:27-05:00"
description: "check-version-currency.sh reports how far each pinned tool is behind upstream, and it warns without blocking."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:27-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/check-version-currency.sh"
---

# Version currency check

`scripts/check-version-currency.sh` reports version currency: how far each pinned tool is behind upstream. It warns and does not block. It runs in the `repo-gate` job and as `make check-currency`.

## Why

The CVE gate in `trusted-devcontainer-templates` records advisories in tool binaries and does not block on them. That rule is correct only when the tools stay current. Before this check, a person found old pins only when they read a CVE report.

## How it works

* It reads the primary version option of each feature: `target_version`, `target_uv_version` or `python_version`.
* It asks the upstream of each feature for the latest version: GitHub releases, `go.dev`, PyPI, `nodejs.org`, the .NET blob, Adoptium or the npm registry.
* `nodejs`, `dotnet` and `openjdk` compare within the declared major line.
* `pnpm` follows the npm dist-tag `latest-10`.
* It also checks the `npm_version` option of `nodejs` against the npm `latest` tag.
* `claude-code`, `openai-codex`, `python` and `bootstrap` are `n/a`: their pin is not a comparable release.

## Output

A table with the columns feature, pinned, latest and state (`current`, `behind`, `unknown`, `n/a`), then the counts `behind` and `unknown`. In CI, the table also goes to the job summary.

A network failure gives `unknown`, never `current`. `--max-behind N` makes the script fail when more than N features are behind. No caller uses it yet.

## Related

* [On 2026-10-28, kaniko is the only feature pin behind upstream](/findings/on-2026-10-28-kaniko-is-the-only-feature-pin-behind-upstream--01a1838267fd.md)
* [The currency check skips the bootstrap, ruff and sqlpackage pins](/issues/the-currency-check-skips-the-bootstrap-ruff-and-sqlpackage-pins--01a183826696.md)
* [No check reported how far pinned tools were behind upstream](/issues/no-check-reported-how-far-pinned-tools-were-behind-upstream--01a1838262eb.md)
* [Check version currency and update a pin](/operations/check-version-currency-and-update-a-pin--01a1837fe233.md)
* [Version pins check](/supply-chain/version-pins-check--01a1837fdfc3.md)
* [Findings overview](/findings/findings-overview--01a1837af700.md) — dated currency results.
* [Static checks](/supply-chain/static-checks--01a1837fe0c4.md)
* [Supply chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
