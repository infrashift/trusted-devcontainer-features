# OpenAI Codex Feature

Installs [OpenAI Codex CLI](https://www.npmjs.com/package/@openai/codex).

## Install Location

- Binary: `~/.bun/bin/codex`
- Global packages: `~/.bun/install/global/`

## Versions

See available versions at https://www.npmjs.com/package/@openai/codex?activeTab=versions

## Authentication

OpenAI Codex requires an `OPENAI_API_KEY` to authenticate. You can provide it in several ways:

- **`containerEnv` with `localEnv`** in `devcontainer.json`:
  ```json
  "containerEnv": {
      "OPENAI_API_KEY": "${localEnv:OPENAI_API_KEY}"
  }
  ```
- **`.env` file** referenced from `devcontainer.json`
- **Shell profile** (`~/.bashrc`, `~/.bash_profile`)

## Notes

- Requires Bun runtime (installsAfter bun-feature)
- OpenAI Codex is a Bun executable distributed via npm
- Installs the VS Code extension `openai.chatgpt`
