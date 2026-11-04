---
id: "01a1837f-e143-7b45-b345-1a85df3c4851"
title: "Change a feature and bump its version"
type: "runbook"
tags:
  - "runbook"
  - "feature"
  - "published-drift"
created: "2026-10-28T12:12:38-05:00"
timestamp: "2026-10-28T12:20:27-05:00"
description: "Each change to a feature source needs a new version, or the published drift check fails and the release skips the change."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:27-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/check-published-drift.sh"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/27"
    title: "PR #27 (bun 1.4.4)"
---

# Change a feature and bump its version

Each change to the files of a feature in `src/<id>/` needs a new `version`. `devcontainer features publish` skips a version that exists. Without a bump, the release ships the old bytes again and reports success. The [published drift check](/supply-chain/published-drift-check--01a1837fdf81.md) fails the pull request in this case.

## Procedure

1. Change the files in `src/<id>/`.
2. Increase `version` in `src/<id>/devcontainer-feature.json`. Use a minor bump for a new tool version, for example `bun` 1.4.3 to 1.5.0 in PR #27. Use a patch bump for a fix.
3. If you changed the default tool version, add the checksums of the new version for each architecture to `vars/main.yml`.
4. If you changed the default tool version, add it to `proposals`.
5. Change the version in the `ROLE_ARGS` entry of `test-templates/shared/contract-tests.sh`.
6. Change each test-template option that sets this version.
7. Change `version` and the option default in `docs/src/data/features.json`.
8. Run `make check-version-pins` and `make check-published-drift`.

   WARNING: If the feature is `bootstrap`, use [Change the bootstrap feature](/operations/change-the-bootstrap-feature--01a1837fe171.md) instead.
9. Run `make test-template TEMPLATE=<template>` and `make test-contract TEMPLATE=<template>` for a template that installs the feature.
10. Open a pull request.

## Result

`check-published-drift` reports the feature as `new: not yet published`. After the merge, the release publishes the new version.

## Related

* [Published drift check](/supply-chain/published-drift-check--01a1837fdf81.md)
* [Version pins check](/supply-chain/version-pins-check--01a1837fdfc3.md)
* [Check version currency and update a pin](/operations/check-version-currency-and-update-a-pin--01a1837fe233.md)
* [Release and promote the features](/operations/release-and-promote-the-features--01a1837fe1e1.md)
* [Operations overview](/operations/operations-overview--01a1837af719.md)
