---
id: "01a18382-616d-7036-97cb-df7790082045"
title: "The python feature skipped the interpreter install after uv-ruff"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "resolved"
  - "python"
  - "uv-ruff"
created: "2026-10-28T12:15:22-05:00"
timestamp: "2026-10-28T12:20:56-05:00"
description: "uv tool install ruff made uv python find succeed with no python3.14 executable; PR #22 always runs uv python install."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:56-05:00"
status: "deprecated"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/22"
    title: "PR #22"
---

# The python feature skipped the interpreter install after uv-ruff

A `python` and `uv-ruff` image had CPython 3.14.7 in `~/.local/share/uv/python` but no `~/.local/bin/python3.14`.

## Problem

`python` installs after `uv-ruff`. `uv tool install ruff` downloads a managed CPython as a tool dependency, but it makes no executable. The `python` role then ran `uv python find 3.14`, which succeeded. So the role skipped `uv python install`.

## Context

* The defect stayed hidden while the two features had different Python defaults. PR #21 moved both to 3.14.
* The image was the `neovim-python` seed, deployed on gcloud-dc.

## Acceptance criteria

- [x] The role always runs `uv python install`, and stays idempotent.
- [x] The role asserts that the executable exists.
- [x] The `python` and `ansible-cue` test templates check `python3.14 --version`.

## Resolution

* Date: 2026-09-27. PR #22 (merge `8b5b764`). `python` moved from 1.7.0 to 1.7.1.
* `changed_when` keys on the `is already installed` output, so a second run reports `changed=0`.

## Related

* [Feature: python](/features/feature-python--01a183801082.md)
* [CPython 3.13 had CVE-2026-82049 with no fix on its line](/issues/cpython-3-13-had-cve-2026-82049-with-no-fix-on-its-line--01a183826199.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
