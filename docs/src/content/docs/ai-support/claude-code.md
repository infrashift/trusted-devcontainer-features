---
title: Claude Code in DevContainers
description: Setting up and using Claude Code (Anthropic's AI coding assistant) in DevContainers.
---

## Overview

Claude Code is Anthropic's AI coding assistant CLI. It can read and edit files, run terminal commands, search your codebase, create commits, and help with complex multi-step software engineering tasks — all from within your DevContainer.

## Installation

Add the Claude Code feature to your `devcontainer.json`:

```jsonc
{
    "features": {
        "ghcr.io/infrashift/trusted-devcontainer-features/bun:latest": {},
        "ghcr.io/infrashift/trusted-devcontainer-features/claude-code:latest": {
            "target_version": "latest"
        }
    }
}
```

The Bun feature is required as a dependency — Claude Code is installed as a global npm package via Bun.

## API Key Configuration

Claude Code requires an Anthropic API key. Pass it from your host environment:

```jsonc
{
    "containerEnv": {
        "ANTHROPIC_API_KEY": "${localEnv:ANTHROPIC_API_KEY}"
    }
}
```

Alternatively, set the key in a `.env` file or configure it after container startup with `claude config`.

## VS Code Extension

The feature automatically recommends the `anthropics.claude-code` VS Code extension, which provides:

- Inline chat with Claude in the editor
- Code suggestions and completions
- Terminal integration for Claude Code CLI

## CLI Usage

Once inside your DevContainer, use Claude Code from the terminal:

```bash
# Start an interactive session
claude

# Ask a question
claude "explain the authentication flow in this codebase"

# Run in non-interactive mode
claude -p "add error handling to the API endpoint in server.ts"
```

## Example Workflows

### Code Review
```bash
claude "review the changes in my current git diff and suggest improvements"
```

### Test Writing
```bash
claude "write unit tests for the UserService class"
```

### Debugging
```bash
claude "the /api/users endpoint returns 500 — investigate and fix"
```

## Security Considerations

- **API keys**: Never commit API keys to version control. Use `containerEnv` with `localEnv` references or secrets management.
- **Egress filtering**: Pair with the [Egress Filter](/trusted-devcontainer-features/ai-support/egress-filter/) feature to restrict network access to only `api.anthropic.com` and other required domains.
- **Container isolation**: Claude Code runs within the DevContainer boundary and cannot access your host filesystem beyond the mounted workspace.
