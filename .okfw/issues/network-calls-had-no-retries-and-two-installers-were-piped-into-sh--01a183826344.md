---
id: "01a18382-6344-7b5a-810b-6e83e913ae3d"
title: "Network calls had no retries, and two installers were piped into sh"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "resolved"
  - "ci"
created: "2026-10-28T12:15:22-05:00"
timestamp: "2026-10-28T12:20:56-05:00"
description: "Nine curl calls had no retry and syft and grype installed through curl to sh; PR #12 adds one retry helper and downloads first."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:56-05:00"
status: "deprecated"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/12"
    title: "PR #12"
---

# Network calls had no retries, and two installers were piped into sh

Eleven `curl` calls in two scripts had weak or no retries. The syft and grype installers ran through `curl | sh`.

## Problem

`check-version-currency.sh` calls seven hosts on each run. `api.github.com` limits unauthenticated callers, so one failed call was likely. In `install-tools.sh`, a pipe into `sh` cannot be retried safely: if the transfer stops, `sh` has already run part of the installer.

## Context

* The retry set does not include `--retry-all-errors`. A 404 shows a wrong pin or a renamed endpoint, and must show at once.
* `install-tools.sh` was byte-identical to the copy in the templates repository before the fix.

## Acceptance criteria

- [x] Each `curl` call uses `--retry 3 --retry-delay 2 --retry-connrefused`.
- [x] The syft and grype installers download to a file before they run.

## Resolution

* Date: 2026-08-24. PR #12 (merge `20c2ede`).
* Each script has one fetch helper. `install-tools.sh` has a shared `install_anchore()` function.
* A live run resolved 18 features with 0 unknown.

## Related

* [No check reported how far pinned tools were behind upstream](/issues/no-check-reported-how-far-pinned-tools-were-behind-upstream--01a1838262eb.md)
* [Supply-chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
