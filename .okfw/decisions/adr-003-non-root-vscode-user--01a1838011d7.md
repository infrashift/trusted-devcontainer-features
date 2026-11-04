---
id: "01a18380-11d7-7929-8411-4c10da24485d"
title: "ADR-003: Non-root vscode user"
type: "decision"
tags:
  - "decision"
  - "adr-003"
  - "dev-user"
  - "superseded"
created: "2026-10-28T12:12:50-05:00"
timestamp: "2026-10-28T12:17:22-05:00"
description: "Superseded by ADR-011: the features installed for a vscode user with UID and GID 1000."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:22-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/decisions/adr-003-non-root-vscode-user.md"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/test-templates/shared/Containerfile"
    title: "Shared test Containerfile"
---

# ADR-003: Non-root vscode user

ADR-003 made `vscode`, with UID and GID 1000, the user that the features installed software for. The features installed into `/home/vscode/.local/bin` and related paths.

**Status:** Superseded by [ADR-011: dev user alignment](/decisions/adr-011-dev-user-alignment--01a183801339.md).

## Decision

Use a non-root `vscode` user with UID 1000 for the development shell. Install user-scoped tools in the home of that user.

## Code check on 2026-10-28

The code no longer follows this ADR. The dev user is `dev` with UID 1001 in `test-templates/shared/Containerfile`. The runner takes the user and the home from `_REMOTE_USER` and `_REMOTE_USER_HOME`. No feature hard-codes `vscode` as a user. The word `vscode` in `devcontainer-feature.json` files is the `customizations.vscode` block.

## Features affected

All features that install into the home of the dev user.

## Related

* [ADR-011: dev user alignment](/decisions/adr-011-dev-user-alignment--01a183801339.md) — the replacement.
* [Decisions overview](/decisions/decisions-overview--01a1837af6ce.md)
