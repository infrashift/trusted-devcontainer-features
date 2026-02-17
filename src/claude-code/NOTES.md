# Claude Code Feature

Installs [Claude Code](https://www.npmjs.com/package/@anthropic-ai/claude-code) (Anthropic's AI coding assistant CLI).

## Install Location

- Binary: `~/.bun/bin/claude`
- Global packages: `~/.bun/install/global/`

## Versions

See available versions at https://www.npmjs.com/package/@anthropic-ai/claude-code?activeTab=versions

## Authentication

Claude Code requires an `ANTHROPIC_API_KEY` to authenticate. You can provide it in several ways:

- **`containerEnv` with `localEnv`** in `devcontainer.json`:
  ```json
  "containerEnv": {
      "ANTHROPIC_API_KEY": "${localEnv:ANTHROPIC_API_KEY}"
  }
  ```
- **`.env` file** referenced from `devcontainer.json`
- **Shell profile** (`~/.bashrc`, `~/.bash_profile`)

## Notes

- Requires Bun runtime (installsAfter bun-feature)
- Claude Code is a Bun executable distributed via npm
- Installs the VS Code extension `anthropics.claude-code`
