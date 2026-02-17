---
title: "ADR-007: Feature Dependency Model"
description: Decision to use installsAfter for declarative feature dependency ordering.
---

**Status:** Accepted

## Context

Some features depend on others — for example, Claude Code needs Bun, npm needs Node.js, and Python needs UV. The Dev Container specification provides `installsAfter` as a mechanism for declaring installation order. We needed a strategy for managing these dependencies.

## Decision

Use `installsAfter` declarations in each feature's `devcontainer-feature.json` to express dependencies. The Dev Container runtime uses these to determine installation order. Dependencies are expressed as relative references (e.g., `"./bun"`) within the feature set.

Current dependency chains:
- `git-lfs` → `git`
- `npm` → `nodejs`
- `pnpm` → `nodejs`
- `cuelang` → `golang`
- `python` → `uv-ruff`
- `ansible-core` → `python`
- `claude-code` → `bun`
- `openai-codex` → `bun`

## Consequences

- **Positive**: Declarative dependencies — the runtime resolves the graph automatically.
- **Positive**: Users don't need to know or manage installation order.
- **Positive**: Dependencies are visible in each feature's metadata for tooling and documentation.
- **Negative**: `installsAfter` only controls ordering, not mandatory inclusion. Users must explicitly add all required features.
- **Negative**: The Dev Container spec doesn't support dependency version constraints — only ordering.

## Alternatives Considered

- **Bundled features**: Bundle dependencies into each feature (e.g., include Bun inside Claude Code). Rejected due to duplication and version conflicts when multiple features need the same dependency.
- **No declared dependencies**: Let users figure out ordering. Rejected because it creates a poor developer experience and hard-to-debug failures.
- **Custom dependency resolution**: Build our own dependency resolver. Rejected because `installsAfter` is the standard mechanism and works for our needs.
