---
id: "01a1837f-df0a-7022-b252-3ba189a72016"
title: "Deploy Documentation workflow"
type: "workflow"
tags:
  - "supply-chain"
  - "workflow"
  - "docs"
created: "2026-10-28T12:12:37-05:00"
timestamp: "2026-10-28T12:20:27-05:00"
description: "deploy-docs.yaml builds the Astro Starlight site in docs/ with Bun and deploys it to GitHub Pages on a push to main."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:27-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/.github/workflows/deploy-docs.yaml"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/astro.config.mjs"
    title: "docs/astro.config.mjs"
---

# Deploy Documentation workflow

The `Deploy Documentation` workflow (`.github/workflows/deploy-docs.yaml`) builds the documentation site in `docs/` and deploys it to GitHub Pages. The site is at `https://infrashift.github.io/trusted-devcontainer-features`.

## Trigger

* `push` to `main` when a file in `docs/**` changes.
* `workflow_dispatch`.
* Concurrency group `pages`, with `cancel-in-progress: false`.

## Jobs

| Job | Environment | What it does |
|---|---|---|
| `build` | none | Installs Bun with `oven-sh/setup-bun` (pinned `bun-version`), runs `bun install --frozen-lockfile` and `bun run build`, uploads `docs/dist`. |
| `deploy` | `github-pages` | Runs `actions/deploy-pages` with `pages: write` and `id-token: write`. |

## Signing actor

None.

## Required status

None.

## Related

* [Run the documentation site locally](/operations/run-the-documentation-site-locally--01a1837fe289.md)
* [Workflow lint](/supply-chain/workflow-lint--01a1837fe026.md)
* [Decisions overview](/decisions/decisions-overview--01a1837af6ce.md) — the ADRs are on the site.
* [Supply chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
