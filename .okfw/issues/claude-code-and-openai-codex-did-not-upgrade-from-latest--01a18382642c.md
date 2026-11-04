---
id: "01a18382-642c-7a81-8508-5410c43441cd"
title: "claude-code and openai-codex did not upgrade from latest"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "resolved"
  - "claude-code"
  - "openai-codex"
created: "2026-10-28T12:15:23-05:00"
timestamp: "2026-10-28T12:20:56-05:00"
description: "The roles skipped the install when any version was present and the option was latest; commit 4aa3e85 resolves the dist-tag first."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:56-05:00"
status: "deprecated"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/1"
    title: "PR #1"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/commit/4aa3e85"
    title: "Commit 4aa3e85"
---

# claude-code and openai-codex did not upgrade from latest

`claude-code` and `openai-codex` default `target_version` to the npm dist-tag `latest`. After the first install, the features never upgraded.

## Problem

The install task ran only when `version != "latest" and version not in stdout`. With `latest`, the first condition was false. So when any version was present, the role skipped the install.

## Context

* This was TODO 15 in the old `TODO.md`.

## Acceptance criteria

- [x] The role resolves the `latest` dist-tag to a concrete version before it compares.
- [x] The final assert checks that exact version.

## Resolution

* Date: 2026-08-24. PR #1, commit `4aa3e85`.
* Both roles have the task `Resolve the ... dist-tag to a concrete version`.
* The commit tested a downgrade of claude-code to 2.1.240 and a request for `latest`.

## Related

* [Feature: claude-code](/features/feature-claude-code--01a183800d91.md)
* [Feature: openai-codex](/features/feature-openai-codex--01a183800ffe.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
