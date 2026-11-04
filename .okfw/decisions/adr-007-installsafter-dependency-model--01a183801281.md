---
id: "01a18380-1281-7192-b629-1a694a6a4772"
title: "ADR-007: installsAfter dependency model"
type: "decision"
tags:
  - "decision"
  - "adr-007"
  - "dependencies"
  - "superseded"
created: "2026-10-28T12:12:51-05:00"
timestamp: "2026-10-28T12:17:22-05:00"
description: "Superseded by ADR-009: features declared their dependencies only with installsAfter, which orders features but does not install them."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:22-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/decisions/adr-007-feature-dependency-model.md"
---

# ADR-007: installsAfter dependency model

ADR-007 declared the dependencies between features with `installsAfter` only, with relative references such as `./bun`. `installsAfter` sets the install order. It does not add the other feature, so the user had to list each required feature.

**Status:** Superseded by [ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md).

## Decision

Use `installsAfter` in `devcontainer-feature.json`. The ADR lists eight chains. `git-lfs` comes after `git`, and `npm` and `pnpm` come after `nodejs`. `cuelang` comes after `golang`, `python` after `uv-ruff`, and `ansible-core` after `python`. `claude-code` and `openai-codex` come after `bun`.

## Code check on 2026-10-28

The code keeps all these `installsAfter` entries. It adds `./nodejs` to `claude-code` and `openai-codex`, `./openjdk` to `gradle` and `maven`, and `./dotnet` to `sqlpackage`. [ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md) adds `dependsOn` for `bootstrap` on top.

## Features affected

[Feature: git-lfs](/features/feature-git-lfs--01a183800e4e.md), [Feature: npm](/features/feature-npm--01a183800fd2.md), [Feature: pnpm](/features/feature-pnpm--01a183801056.md), [Feature: cuelang](/features/feature-cuelang--01a183800db4.md), [Feature: python](/features/feature-python--01a183801082.md), [Feature: ansible-core](/features/feature-ansible-core--01a183800d2e.md), [Feature: claude-code](/features/feature-claude-code--01a183800d91.md), [Feature: openai-codex](/features/feature-openai-codex--01a183800ffe.md).

## Related

* [ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md) — the replacement for mandatory dependencies.
* [Decisions overview](/decisions/decisions-overview--01a1837af6ce.md)
