---
id: "01a1837a-f7f3-78f6-abb0-eed982e5a581"
title: "Adopt OKF Wiki for project knowledge"
type: "plan"
tags:
  - "plan"
  - "active"
  - "okfw"
created: "2026-10-28T12:07:16-05:00"
timestamp: "2026-10-28T12:08:38-05:00"
description: "Put the project knowledge from the docs site, PR history and agent memory into one OKF wiki in .okfw/, written in Simplified Technical English."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:08:38-05:00"
status: "draft"
sources:
  - resource: "https://github.com/infrashift/okf-wiki"
    title: "okf-wiki (okfw)"
  - resource: "https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md"
    title: "OKF specification"
---

# Adopt OKF Wiki for project knowledge

This plan puts the project knowledge into one OKF wiki in `.okfw/`. Humans and AI agents read and write the same wiki. The maintainer approved this plan on 2026-10-28.

## Goal

One wiki in `.okfw/` holds the project knowledge that the code does not show. The wiki shows a small amount first and more on request. All prose obeys [Simplified Technical English](/guides/simplified-technical-english--01a1837af766.md).

## Context

* The knowledge is in many places. These are the documentation site, `SETUP-ENVIRONMENTS.md`, comments in scripts and workflows, 31 PR descriptions and agent memory.
* The documentation site has 12 ADRs, 27 feature pages, and pages for the architecture, the roadmap and contributions.
* No place exists for plans, open issues or dated findings. The repository has no GitHub issues and no `TODO.md`.
* The repository `trusted-devcontainer-templates` adopted the same wiki structure on 2026-10-28. This wiki copies its guides and bundles.

Decisions of the maintainer:

1. The scope is this repository only. Link to the templates wiki by GitHub URL where the two repositories meet.
2. Copy the five guides from the templates wiki, and change them for features.
3. Add `CLAUDE.md`, `AGENTS.md` and `.mcp.json`.
4. Record only notable history: real defects and advisory fixes. Do not record routine version changes.

## Disclosure levels

| Level | The reader reads |
|---|---|
| 0 | The `okfw` block in `CLAUDE.md` and `AGENTS.md`, the root `index.md` and the wiki map |
| 1 | The `index.md` and the overview of one bundle |
| 2 | One concept, with one idea and a one-sentence description |
| 3 | The `resource` and `sources` of a concept |

## Steps

1. Create the branch `chore/okf-wiki-init`.
2. Run `okfw init` and `okfw connect`.
3. Write `CLAUDE.md` and `AGENTS.md`. Run `okfw install --platform claude` and `okfw install --platform codex`. Add `.mcp.json`.
4. Create the wiki map, the nine bundle overviews and the concepts in `guides/`.
5. Give the content to three agents. Each agent writes only its own bundles:
   * Agent A: `features/` and `decisions/`.
   * Agent B: `architecture/`, `supply-chain/` and `operations/`.
   * Agent C: `issues/`, `findings/` and `plans/`.
6. Run `okfw index-md`. Add the links between bundles. Remove each dangling link.
7. Add `/.okfw/`, `/CLAUDE.md`, `/AGENTS.md` and `/.mcp.json` to `.github/CODEOWNERS`. Add a section "Project knowledge" to `README.md`.
8. Show the result to the maintainer. Commit and open a pull request only on request.

## Verification

1. `okfw validate --all` and `okfw validate --okf` pass.
2. `okfw graph-query dangling` returns nothing.
3. Each line in the root `index.md` and in each bundle `index.md` has a description.
4. `okfw search --kind issue --tag open` and `okfw search --type plan --tag active` return the expected concepts.
5. `make repo-gate` finds no secret in `.okfw/`.
6. A check of 10 concepts finds no STE errors.
7. In a new Claude Code session, `CLAUDE.md` loads, the `okfw` skill shows, and an MCP search answers "why is bootstrap a dependsOn of every feature".

## Related

* [Plan workflow](/guides/plan-workflow--01a1837af7d6.md)
* [Wiki conventions](/guides/wiki-conventions--01a1837af79c.md)
* [Wiki map](/wiki-map--01a1837af671.md)
* [Plans overview](/plans/plans-overview--01a1837af74b.md)
