---
id: "01a18382-62c3-7949-9c7b-c73658b5c178"
title: "Test copies of the version defaults drifted from the declared defaults"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "resolved"
  - "testing"
  - "pinning"
created: "2026-10-28T12:15:22-05:00"
timestamp: "2026-10-28T12:20:56-05:00"
description: "ROLE_ARGS and test template files held stale copies of option defaults; check-version-pins.sh from PR #3 and commit 1b5fddc now compares them."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:56-05:00"
status: "deprecated"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/3"
    title: "PR #3"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/commit/1b5fddc"
    title: "Commit 1b5fddc"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/check-version-pins.sh"
---

# Test copies of the version defaults drifted from the declared defaults

`ROLE_ARGS` in `contract-tests.sh` and the test template `devcontainer.json` files held copies of the option defaults. Nothing kept them the same as `devcontainer-feature.json`.

## Problem

After a version bump, the contract tests asserted idempotency at the old version. The test passed, because a role is idempotent at any version that it gets. On 2026-08-24 the `ansible-cue` contract test reported `changed=1`: the image had ansible-core 2.18.2, but the contract test asked for 2.21.3.

## Context

* `test-templates/ansible-cue/.devcontainer/devcontainer.json` set `target_version` explicitly. It was a third copy of the default.
* The first version of the guard searched the whole JSON for the version string. It passed, because `proposals` lists old versions.

## Acceptance criteria

- [x] A check compares `ROLE_ARGS` values with the declared defaults.
- [x] The same check covers the version values in the test templates.
- [x] The check compares with the `default` field, not the whole file.

## Resolution

* Date: 2026-08-24. PR #3 (commit `ad80823`) added `scripts/check-version-pins.sh`. It runs in `pr-gate` and `make check`.
* Date: 2026-08-24. PR #5 (commit `1b5fddc`) extended it to the test templates. The pin count went from 18 to 22.

## Related

* [Version pins check](/supply-chain/version-pins-check--01a1837fdfc3.md)
* [Feature tool pins were far behind upstream](/issues/feature-tool-pins-were-far-behind-upstream--01a183826297.md)
* [Supply-chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
