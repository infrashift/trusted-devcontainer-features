---
id: "01a1837f-ddea-724f-a369-b9506c957e7d"
title: "Feature dependency model"
type: "component"
tags:
  - "architecture"
  - "dependency"
  - "bootstrap"
created: "2026-10-28T12:12:37-05:00"
timestamp: "2026-10-28T12:20:26-05:00"
description: "Every feature has dependsOn bootstrap, pinned by digest at publish time, so bootstrap publishes first; installsAfter only orders features."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:26-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/decisions/adr-009-mandatory-dependencies.md"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/rewrite-feature-refs.sh"
    title: "scripts/rewrite-feature-refs.sh"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/.github/workflows/release.yaml"
    title: "release.yaml"
---

# Feature dependency model

Every feature except `bootstrap` declares `dependsOn` the `bootstrap` feature (ADR-009). `dependsOn` makes the devcontainer CLI install `bootstrap` also when a template does not list it. `installsAfter` gives only the order between features that the consumer selected.

## In the source

The source uses relative references:

```jsonc
"installsAfter": ["./uv-ruff"],
"dependsOn": { "./bootstrap": {} }
```

The relative form lets the test templates and the maintainer dev container use the working tree. It is not correct in a published feature: the consumer CLI resolves `./bootstrap` against its own `.devcontainer/`.

## At publish time

1. The release publishes `bootstrap` first and reads its production digest.
2. `scripts/rewrite-feature-refs.sh` changes each `./<id>` to `ghcr.io/infrashift/trusted-devcontainer-features/<id>`.
3. In `dependsOn` only, it adds `@<bootstrap digest>`. `installsAfter` keeps the reference without a digest, because the CLI matches it by id.
4. The release then publishes the dependents.

A digest is known only after a publish. Thus the release has two phases. See [Release workflow](/supply-chain/release-workflow--01a1837fdeee.md).

## Order-only relations (`installsAfter`)

| Feature | Installs after |
|---|---|
| `ansible-core` | `python` |
| `claude-code`, `openai-codex` | `bun`, `nodejs` |
| `cuelang` | `golang` |
| `git-lfs` | `git` |
| `maven`, `gradle` | `openjdk` |
| `npm`, `pnpm` | `nodejs` |
| `python` | `uv-ruff` |
| `sqlpackage` | `dotnet` |

Read the current values in `src/<id>/devcontainer-feature.json`.

## Analysis

* A digest pin is immutable. A `bootstrap` change reaches a consumer only when each dependent is published again. The [Bootstrap fan-out check](/supply-chain/bootstrap-fan-out-check--01a1837fdfa2.md) enforces this.

## Related

* [ADR-007: installsAfter dependency model](/decisions/adr-007-installsafter-dependency-model--01a183801281.md)
* [ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md)
* [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md)
* [Feature reference rewrite](/supply-chain/feature-reference-rewrite--01a1837fe005.md)
* [Stage, review and promote by digest](/supply-chain/stage-review-and-promote-by-digest--01a1837fdf62.md)
* [Bootstrap environment](/architecture/bootstrap-environment--01a1837fdda1.md)
* [Decisions overview](/decisions/decisions-overview--01a1837af6ce.md) — ADR-007 and ADR-009.
* [Architecture overview](/architecture/architecture-overview--01a1837af69f.md)
