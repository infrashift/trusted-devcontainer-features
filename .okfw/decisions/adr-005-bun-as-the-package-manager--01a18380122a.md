---
id: "01a18380-122a-7e8c-bd96-af3f2096b6c6"
title: "ADR-005: Bun as the package manager"
type: "decision"
tags:
  - "decision"
  - "adr-005"
  - "bun"
  - "claude-code"
  - "openai-codex"
created: "2026-10-28T12:12:50-05:00"
timestamp: "2026-10-28T12:17:22-05:00"
description: "Accepted: Bun installs the claude-code and openai-codex CLIs, and Bun manages the documentation site."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:22-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/decisions/adr-005-bun-as-package-manager.md"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/claude-code/ansible-role-feature/tasks/main.yml"
    title: "claude-code role tasks"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/Makefile"
    title: "Makefile docs-dev target"
---

# ADR-005: Bun as the package manager

ADR-005 makes Bun the JavaScript runtime and package manager of the project. In the features, Bun installs global npm packages: the Claude Code and OpenAI Codex CLIs. For the documentation site, Bun replaces npm, yarn and pnpm.

**Status:** Accepted.

## Decision

Use Bun, because it is fast and is one binary with no dependencies. The cost is that Bun is newer than npm, and some npm packages can have compatibility problems.

## Code check on 2026-10-28

The code agrees. The `claude-code` and `openai-codex` roles run `~/.local/bin/bun install -g`. The docs site has `docs/bun.lock`, and `make docs-dev` runs `bun --bun run dev`. Both CLI features also have `./nodejs` in `installsAfter`, which the ADR does not mention.

## Features affected

[Feature: bun](/features/feature-bun--01a183800d6f.md), [Feature: claude-code](/features/feature-claude-code--01a183800d91.md), [Feature: openai-codex](/features/feature-openai-codex--01a183800ffe.md).

## Related

* [ADR-007: installsAfter dependency model](/decisions/adr-007-installsafter-dependency-model--01a183801281.md) — the old `installsAfter` link from the CLIs to Bun.
* [Decisions overview](/decisions/decisions-overview--01a1837af6ce.md)
