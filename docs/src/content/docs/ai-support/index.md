---
title: AI-Powered DevContainers
description: Using AI coding assistants securely inside DevContainers.
---

## Overview

Infrashift DevContainer Features includes first-class support for AI coding assistants. Run Claude Code or OpenAI Codex directly inside your development container with full access to your project files, terminal, and development tools.

## Why AI Assistants in DevContainers?

DevContainers provide the ideal environment for AI coding assistants:

- **Isolation**: AI agents operate within a container boundary, not on your host machine
- **Reproducibility**: Every team member gets the same AI tooling configuration
- **Security**: Combine with egress filtering to control what domains AI agents can access
- **Consistency**: Pin specific versions of AI tools across your team

## Available Features

### Claude Code

[Claude Code](/trusted-devcontainer-features/features/claude-code/) installs Anthropic's AI coding assistant CLI. Claude Code can read and edit files, run terminal commands, search your codebase, and help with complex software engineering tasks.

- Installed via Bun as a global npm package
- Requires `ANTHROPIC_API_KEY` environment variable
- VS Code extension: `anthropics.claude-code`

[Claude Code deep-dive →](/trusted-devcontainer-features/ai-support/claude-code/)

### OpenAI Codex

[OpenAI Codex](/trusted-devcontainer-features/features/openai-codex/) installs OpenAI's Codex CLI for code generation and assistance.

- Installed via Bun as a global npm package
- Requires `OPENAI_API_KEY` environment variable
- VS Code extension: `openai.chatgpt`

[OpenAI Codex deep-dive →](/trusted-devcontainer-features/ai-support/openai-codex/)

### Egress Filtering

For security-conscious environments, the [Egress Filter](/trusted-devcontainer-features/features/egress-filter/) feature lets you restrict which domains AI agents can access.

[Egress filtering for AI →](/trusted-devcontainer-features/ai-support/egress-filter/)

## Quick Start

Add both an AI assistant and egress filtering to your `devcontainer.json`:

```jsonc
{
    "features": {
        "ghcr.io/infrashift/trusted-devcontainer-features/bun:latest": {},
        "ghcr.io/infrashift/trusted-devcontainer-features/claude-code:latest": {},
        "ghcr.io/infrashift/trusted-devcontainer-features/egress-filter:latest": {
            "allowed_domains": ".anthropic.com,.github.com,api.anthropic.com"
        }
    },
    "containerEnv": {
        "ANTHROPIC_API_KEY": "${localEnv:ANTHROPIC_API_KEY}"
    }
}
```
