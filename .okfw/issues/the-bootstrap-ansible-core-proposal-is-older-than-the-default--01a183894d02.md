---
id: "01a18389-4d02-7b39-b692-fb250b02bce4"
title: "The bootstrap ansible-core proposal is older than the default"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "open"
  - "bootstrap"
created: "2026-10-28T12:22:55-05:00"
timestamp: "2026-10-28T12:24:37-05:00"
description: "The ansible_core_version option of bootstrap proposes 2.18.2, but its default is 2.21.3."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:24:37-05:00"
status: "draft"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/bootstrap/devcontainer-feature.json"
    title: "bootstrap devcontainer-feature.json"
---

# The bootstrap ansible-core proposal is older than the default

The `ansible_core_version` option of `bootstrap` proposes `2.18.2`, but its default is `2.21.3`. A user who picks the proposal in an editor gets an old ansible-core.

## Problem

`src/bootstrap/devcontainer-feature.json` lines 21–25 set `"proposals": ["2.18.2"]` and `"default": "2.21.3"`.

## Context

`make check-version-pins` compares test pins with the defaults. It does not compare `proposals` with `default`. The 2.18.2 value also appears in the maintainer dev container.

## Acceptance criteria

- [ ] The proposals list contains the default.
- [ ] A check finds a proposals list that does not contain the default, for every feature.

## Related

* [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md)
* [Version pins check](/supply-chain/version-pins-check--01a1837fdfc3.md)
* [The maintainer dev container pins old versions and the deprecated npm feature](/issues/the-maintainer-dev-container-pins-old-versions-and-the-deprecated-npm-feature--01a183894d35.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
