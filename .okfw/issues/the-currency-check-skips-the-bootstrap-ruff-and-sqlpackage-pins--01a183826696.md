---
id: "01a18382-6696-74b1-8009-ed0ee71a9799"
title: "The currency check skips the bootstrap, ruff and sqlpackage pins"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "open"
  - "version-currency"
  - "bootstrap"
  - "uv-ruff"
  - "sqlpackage"
created: "2026-10-28T12:15:23-05:00"
timestamp: "2026-10-28T12:20:48-05:00"
description: "check-version-currency.sh does not compare bootstrap uv and ansible-core or uv-ruff ruff, and always reports sqlpackage as unknown."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:48-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/check-version-currency.sh"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/bootstrap/devcontainer-feature.json"
    title: "src/bootstrap/devcontainer-feature.json"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/25"
    title: "PR #25"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/28"
    title: "PR #28"
---

# The currency check skips the bootstrap, ruff and sqlpackage pins

`scripts/check-version-currency.sh` compares one primary version for each feature. Four pinned versions get no comparison with upstream.

## Problem

* `bootstrap` pins `uv_version` 0.12.24 and `ansible_core_version` 2.21.3. The script reports `bootstrap` as "minor line, not a patch release", because it reads only `python_version`.
* `uv-ruff` pins `target_ruff_version` 0.17.3. The script reads only `target_uv_version`.
* `sqlpackage` has no upstream lookup in `latest_for()`, so it is always `unknown`.

## Context

* Measured on 2026-10-28: the `uv-ruff` feature pins uv 0.13.6, and the `ansible-core` feature pins 2.21.5. `bootstrap` pins older versions of both. See [On 2026-10-28, kaniko is the only feature pin behind upstream](/findings/on-2026-10-28-kaniko-is-the-only-feature-pin-behind-upstream--01a1838267fd.md).
* PR #25 and PR #28 kept the `bootstrap` pins on purpose: a `bootstrap` change makes all 26 dependents republish.
* The `bootstrap` Python is in every template. [uv 0.12.5 installed CPython 3.14.7, which has two CVEs](/issues/uv-0-12-5-installed-cpython-3-14-7-which-has-two-cves--01a1838261cb.md) shows that a stale `bootstrap` uv can block every template.
* The script already has `EXTRA_PINS` for a pin that is not the primary version.

## Acceptance criteria

- [ ] The report has a row for `bootstrap` uv, `bootstrap` ansible-core and `uv-ruff` ruff.
- [ ] `sqlpackage` resolves against NuGet, or the script reports it as not comparable with a reason.

## Related

* [Version currency check](/supply-chain/version-currency-check--01a1837fdfe4.md)
* [Check version currency and update a pin](/operations/check-version-currency-and-update-a-pin--01a1837fe233.md)
* [No check reported how far pinned tools were behind upstream](/issues/no-check-reported-how-far-pinned-tools-were-behind-upstream--01a1838262eb.md)
* [On 2026-10-28, kaniko is the only feature pin behind upstream](/findings/on-2026-10-28-kaniko-is-the-only-feature-pin-behind-upstream--01a1838267fd.md)
* [uv 0.12.5 installed CPython 3.14.7, which has two CVEs](/issues/uv-0-12-5-installed-cpython-3-14-7-which-has-two-cves--01a1838261cb.md)
* [Supply-chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
