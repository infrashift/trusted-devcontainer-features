---
id: "01a1837f-e289-7cad-9a10-0b2426711564"
title: "Run the documentation site locally"
type: "runbook"
tags:
  - "runbook"
  - "docs"
created: "2026-10-28T12:12:38-05:00"
timestamp: "2026-10-28T12:20:27-05:00"
description: "Run make docs-dev to start the Astro Starlight site in docs/ with Bun."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:27-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/package.json"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/Makefile"
    title: "Makefile docs-dev target"
---

# Run the documentation site locally

The documentation site in `docs/` is an Astro Starlight site. Bun installs and runs it. The [Deploy Documentation workflow](/supply-chain/deploy-documentation-workflow--01a1837fdf0a.md) publishes it to GitHub Pages.

## Procedure

1. Install Bun. CI uses the `bun-version` in `.github/workflows/deploy-docs.yaml`.
2. Run `cd docs && bun install --frozen-lockfile`.
3. From the repository root, run `make docs-dev`. It runs `bun --bun run dev` in `docs/`.
4. Open the URL that Astro prints. The site uses the base path `/trusted-devcontainer-features`.
5. Before you push, run `bun run build` in `docs/`. CI runs this command.

## Where the content is

| Path | Content |
|---|---|
| `docs/src/content/docs/decisions/` | The ADRs |
| `docs/src/content/docs/features/<id>.mdx` | One page for each feature |
| `docs/src/content/docs/reference/` | `architecture.md`, `contributing.md`, `roadmap.md` |
| `docs/src/data/features.json` | Versions, options and test state that the feature pages show |

## Related

* [Deploy Documentation workflow](/supply-chain/deploy-documentation-workflow--01a1837fdf0a.md)
* [Decisions overview](/decisions/decisions-overview--01a1837af6ce.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
* [Operations overview](/operations/operations-overview--01a1837af719.md)
