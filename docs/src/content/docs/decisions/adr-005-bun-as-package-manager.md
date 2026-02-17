---
title: "ADR-005: Bun as Package Manager"
description: Decision to use Bun for JavaScript-based tooling and documentation site management.
---

**Status:** Accepted

## Context

The project needs a JavaScript runtime and package manager for two purposes: (1) installing Node.js-based CLI tools like Claude Code and OpenAI Codex inside DevContainers, and (2) managing the documentation site's dependencies. We needed a fast, low-overhead solution.

## Decision

Use Bun as the JavaScript runtime and package manager. For DevContainer features, Bun installs global npm packages (Claude Code, OpenAI Codex) via `bun install --global`. For the documentation site, Bun replaces npm/yarn/pnpm for dependency management and build scripts.

## Consequences

- **Positive**: Bun is significantly faster than npm for package installation and script execution.
- **Positive**: Single binary download with no dependencies — simple to install in UBI containers.
- **Positive**: Compatible with the npm registry and package.json format — no ecosystem lock-in.
- **Negative**: Bun is newer and less battle-tested than npm or yarn in enterprise environments.
- **Negative**: Some npm packages may have edge-case compatibility issues with Bun's runtime.

## Alternatives Considered

- **npm**: The default. Rejected for performance reasons — npm is noticeably slower for global installs and documentation site builds.
- **pnpm**: Fast and disk-efficient. Rejected because Bun provides both runtime and package manager in a single tool.
- **yarn**: Rejected. No significant advantage over Bun for our use cases.
