---
id: "01a1837f-dfc3-7409-b64c-482946a9e216"
title: "Version pins check"
type: "component"
tags:
  - "supply-chain"
  - "version-pins"
created: "2026-10-28T12:12:38-05:00"
timestamp: "2026-10-28T12:20:27-05:00"
description: "check-version-pins.sh fails when contract-test ROLE_ARGS or test-template options pin a version that is not a declared default."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:27-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/check-version-pins.sh"
---

# Version pins check

`scripts/check-version-pins.sh` makes sure that two copies of the default versions agree with `devcontainer-feature.json`. It runs in the `repo-gate` job and as `make check-version-pins`.

## The copies that it checks

| Copy | File | Rule |
|---|---|---|
| `ROLE_ARGS` | `test-templates/shared/contract-tests.sh` | Each `_*_version=<value>` must be a declared `default` of that feature |
| Template options | `test-templates/*/.devcontainer/devcontainer.json` | Each option with `version` in its name must be a declared `default` |

The check compares values, not names. Role variable names do not map directly to option names, for example `_openjdk_major_version`. It compares with `default` values only, not `proposals`.

## Why

A contract test is idempotent at any version. When `ROLE_ARGS` kept an old version after a bump, the test passed and tested the wrong version. A test template that set `ansible-core` 2.18.2 after the default changed to 2.21.3 made the contract test report `changed=1`.

## Limit

The check does not read `.devcontainer/devcontainer.json`, the maintainer dev container.

## Related

* [Test copies of the version defaults drifted from the declared defaults](/issues/test-copies-of-the-version-defaults-drifted-from-the-declared-defaults--01a1838262c3.md)
* [The bootstrap ansible-core proposal is older than the default](/issues/the-bootstrap-ansible-core-proposal-is-older-than-the-default--01a183894d02.md)
* [The maintainer dev container pins old versions and the deprecated npm feature](/issues/the-maintainer-dev-container-pins-old-versions-and-the-deprecated-npm-feature--01a183894d35.md)
* [Contract tests](/architecture/contract-tests--01a1837fde81.md)
* [Test templates](/architecture/test-templates--01a1837fde68.md)
* [Check version currency and update a pin](/operations/check-version-currency-and-update-a-pin--01a1837fe233.md)
* [Static checks](/supply-chain/static-checks--01a1837fe0c4.md)
* [Supply chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
