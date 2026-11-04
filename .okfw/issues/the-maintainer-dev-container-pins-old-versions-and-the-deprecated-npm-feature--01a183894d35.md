---
id: "01a18389-4d35-7237-a782-b9d577070733"
title: "The maintainer dev container pins old versions and the deprecated npm feature"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "open"
  - "devcontainer"
  - "npm"
created: "2026-10-28T12:22:55-05:00"
timestamp: "2026-10-28T12:24:37-05:00"
description: "The maintainer devcontainer.json pins Python 3.12 and ansible-core 2.18.2 and installs ./npm; check-version-pins.sh does not read it."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:24:37-05:00"
status: "draft"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/.devcontainer/devcontainer.json"
    title: "Maintainer devcontainer.json"
---

# The maintainer dev container pins old versions and the deprecated npm feature

`.devcontainer/devcontainer.json` pins Python 3.12 and ansible-core 2.18.2, and it installs the deprecated `./npm` feature. No check reads this file, so it drifts from the feature defaults.

## Problem

* Line 55 sets `./python` to `target_version` `3.12`.
* Line 56 sets `./ansible-core` to `target_version` `2.18.2` on Python `3.12`.
* Line 50 installs `./npm`, which is deprecated. `nodejs` now supplies npm through `npm_version`.
* `scripts/check-version-pins.sh` reads the test templates, not `.devcontainer/devcontainer.json`.

## Context

The maintainer dev container is the environment in which a maintainer runs `make check`. Old pins there can hide or cause failures that CI does not show.

## Acceptance criteria

- [ ] The maintainer dev container uses the current defaults, or states why it pins an older version.
- [ ] It does not install `./npm`.
- [ ] `make check-version-pins` also reads `.devcontainer/devcontainer.json`.

## Related

* [Use the maintainer dev container](/operations/use-the-maintainer-dev-container--01a1837fe25c.md)
* [Version pins check](/supply-chain/version-pins-check--01a1837fdfc3.md)
* [Feature: npm](/features/feature-npm--01a183800fd2.md)
* [The npm feature is deprecated only in prose](/issues/the-npm-feature-is-deprecated-only-in-prose--01a183894d6a.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
