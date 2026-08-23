---
title: OpenAI Codex in DevContainers
description: Setting up and using OpenAI Codex CLI in DevContainers.
---

## Overview

OpenAI Codex is OpenAI's CLI tool for AI-assisted coding. It provides code generation, explanation, and editing capabilities powered by OpenAI's models, all accessible from your DevContainer terminal.

## Installation

Add the OpenAI Codex feature to your `devcontainer.json`:

```jsonc
{
    "features": {
        "ghcr.io/infrashift/trusted-devcontainer-features/bun:latest": {},
        "ghcr.io/infrashift/trusted-devcontainer-features/openai-codex:latest": {
            "target_version": "latest"
        }
    }
}
```

The Bun feature is required as a dependency — OpenAI Codex is installed as a global npm package via Bun.

## API Key Configuration

OpenAI Codex requires an OpenAI API key. Pass it from your host environment:

```jsonc
{
    "containerEnv": {
        "OPENAI_API_KEY": "${localEnv:OPENAI_API_KEY}"
    }
}
```

## VS Code Extension

The feature automatically recommends the `openai.chatgpt` VS Code extension for integrated AI assistance within the editor.

## CLI Usage

Once inside your DevContainer, use the Codex CLI:

```bash
# Start an interactive session
codex

# Ask a direct question
codex "refactor this function to use async/await"
```

## Example Workflows

### Code Generation
```bash
codex "create a REST API endpoint for user registration with validation"
```

### Code Explanation
```bash
codex "explain what the deploy.sh script does step by step"
```

### Refactoring
```bash
codex "convert this class component to a functional React component with hooks"
```

## Security Considerations

- **API keys**: Never commit API keys to version control. Use `containerEnv` with `localEnv` references.
- **Container isolation**: Codex runs within the DevContainer boundary and cannot access your host filesystem beyond the mounted workspace.
