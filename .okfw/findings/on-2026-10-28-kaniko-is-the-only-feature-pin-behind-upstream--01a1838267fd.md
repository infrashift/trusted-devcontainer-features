---
id: "01a18382-67fd-7e09-adb6-f4bab88e3b7a"
title: "On 2026-10-28, kaniko is the only feature pin behind upstream"
type: "finding"
tags:
  - "finding"
  - "version-currency"
  - "measurement"
created: "2026-10-28T12:15:24-05:00"
timestamp: "2026-10-28T12:20:56-05:00"
description: "make check-currency on 2026-10-28: 18 pins current, kaniko behind (1.28.6 against 1.29.0), sqlpackage unknown, four not comparable."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:56-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/check-version-currency.sh"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/5"
    title: "PR #5"
stale_after: "2026-11-28T00:00:00Z"
---

# On 2026-10-28, kaniko is the only feature pin behind upstream

On 2026-10-28, `make check-currency` reported 18 pins current, 1 behind, 1 unknown and 4 not comparable. `kaniko` is behind on purpose.

## Source of the measurement

* Command: `./scripts/check-version-currency.sh` (`make check-currency`), run on 2026-10-28 at commit `8f7b695` (branch `chore/okf-wiki-init`).
* Each pin is the `default` of an option in `src/<name>/devcontainer-feature.json`.

## Result

| State | Count | Rows |
|---|---:|---|
| current | 18 | `ansible-core`, `bun`, `cuelang`, `dotnet`, `envbuilder`, `golang`, `gradle`, `grype`, `jq`, `maven`, `nodejs`, `npm`, `openjdk`, `pnpm` (10.x line), `syft`, `uv-ruff` (uv), `yq`, `nodejs` (`npm_version`) |
| behind | 1 | `kaniko` 1.28.6, upstream 1.29.0 |
| unknown | 1 | `sqlpackage` 170.5.76 |
| not comparable | 4 | `bootstrap` and `python` (minor line 3.14), `claude-code` and `openai-codex` (dist-tag `latest`) |

## Earlier runs

| Date | Source | Current | Behind | Not comparable | Unknown |
|---|---|---:|---:|---:|---:|
| 2026-08-24 | PR #5, first run | 11 | 3 (`bun`, `npm`, `pnpm`) | 4 | 0 |
| 2026-10-28 | This run | 18 | 1 (`kaniko`) | 4 | 1 |

## Analysis — not part of the measurement

* `kaniko` is behind because the role cannot install 1.29. See [The kaniko role cannot install kaniko 1.29 or later](/issues/the-kaniko-role-cannot-install-kaniko-1-29-or-later--01a1838266c2.md).
* `sqlpackage` is `unknown` on every run, because the script has no lookup for it. The report does not show the `bootstrap` uv and ansible-core pins or the ruff pin. See [The currency check skips the bootstrap, ruff and sqlpackage pins](/issues/the-currency-check-skips-the-bootstrap-ruff-and-sqlpackage-pins--01a183826696.md).

## Related

* [Version currency check](/supply-chain/version-currency-check--01a1837fdfe4.md)
* [Check version currency and update a pin](/operations/check-version-currency-and-update-a-pin--01a1837fe233.md)
* [Feature: kaniko](/features/feature-kaniko--01a183800f23.md)
* [No check reported how far pinned tools were behind upstream](/issues/no-check-reported-how-far-pinned-tools-were-behind-upstream--01a1838262eb.md)
* [The currency check skips the bootstrap, ruff and sqlpackage pins](/issues/the-currency-check-skips-the-bootstrap-ruff-and-sqlpackage-pins--01a183826696.md)
* [The kaniko role cannot install kaniko 1.29 or later](/issues/the-kaniko-role-cannot-install-kaniko-1-29-or-later--01a1838266c2.md)
* [The pnpm role cannot install pnpm 11 or later](/issues/the-pnpm-role-cannot-install-pnpm-11-or-later--01a1838266f1.md)
* [Supply-chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
* [Findings overview](/findings/findings-overview--01a1837af700.md)
