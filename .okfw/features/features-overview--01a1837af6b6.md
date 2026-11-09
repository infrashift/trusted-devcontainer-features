---
id: "01a1837a-f6b6-78f2-9490-8b7817c420c5"
title: "Features overview"
type: "overview"
tags:
  - "hub"
  - "feature"
created: "2026-10-28T12:07:16-05:00"
timestamp: "2026-10-28T12:07:16-05:00"
description: "One pointer concept for each published feature, with its version, options and dependencies."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:07:16-05:00"
status: "draft"
---

# Features overview

This bundle holds one pointer concept for each feature in `src/`. A concept gives a summary, the options and their defaults, the dependencies, the test templates and the ADRs that shape the feature.

The sources of truth are `src/<name>/devcontainer-feature.json`, the role in `src/<name>/ansible-role-feature/` and the docs page `docs/src/content/docs/features/<name>.mdx`. If the docs page and the code do not agree, the concept records the fact of the code under "Notes".

## Find concepts

* List this bundle: read `.okfw/features/index.md`.
* Search this bundle: `okfw search "<words>" --type feature`.
* Find the concepts about one feature: `okfw search "<name>" --tag <name>`.

## Add a concept

1. Add the feature in `src/<name>/` and its docs page first.
2. Run `okfw create "Feature: <name>" --path features --type feature -d "<one sentence>" --tags feature,<name>`.
3. Set `resource` to the GitHub URL of the docs page. Add `devcontainer-feature.json` and the role as `sources`.
4. Add a link to the new concept in the table below. Obey the [wiki conventions](/guides/wiki-conventions--01a1837af79c.md) and [Simplified Technical English](/guides/simplified-technical-english--01a1837af766.md).

## Concepts

### Runner

| Concept | What it installs |
|---|---|
| [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) | Pinned uv, Python and `ansible-core` in `/opt/bootstrap`, and the runner. Every feature depends on it. |

### Languages and runtimes

| Concept | What it installs |
|---|---|
| [Feature: dotnet](/features/feature-dotnet--01a183800dda.md) | .NET SDK, pinned SHA512 checksum. |
| [Feature: golang](/features/feature-golang--01a183800e75.md) | Go, pinned SHA256 checksum. |
| [Feature: nodejs](/features/feature-nodejs--01a183800fa6.md) | Node.js, and it replaces the bundled npm. |
| [Feature: openjdk](/features/feature-openjdk--01a18380102a.md) | Temurin JDK, pinned SHA256 checksum. |
| [Feature: python](/features/feature-python--01a183801082.md) | Python through `uv python install`. |
| [Feature: bun](/features/feature-bun--01a183800d6f.md) | Bun runtime, pinned SHA256 checksum. |

### Package managers and build tools

| Concept | What it installs |
|---|---|
| [Feature: uv-ruff](/features/feature-uv-ruff--01a183801130.md) | uv and Ruff for the dev user. |
| [Feature: pnpm](/features/feature-pnpm--01a183801056.md) | pnpm standalone binary. |
| [Feature: maven](/features/feature-maven--01a183800f7a.md) | Maven, pinned SHA512 checksum. |
| [Feature: gradle](/features/feature-gradle--01a183800e9f.md) | Gradle, pinned SHA256 checksum. |
| [Feature: sqlpackage](/features/feature-sqlpackage--01a1838010af.md) | SqlPackage as a .NET tool. Needs `dotnet`. |
| [Feature: ansible-core](/features/feature-ansible-core--01a183800d2e.md) | A user `ansible-core` as a uv tool. |
| [Feature: cuelang](/features/feature-cuelang--01a183800db4.md) | The `cue` command. |

### AI CLIs

| Concept | What it installs |
|---|---|
| [Feature: claude-code](/features/feature-claude-code--01a183800d91.md) | Claude Code CLI through Bun. |
| [Feature: openai-codex](/features/feature-openai-codex--01a183800ffe.md) | OpenAI Codex CLI through Bun. |
| [Feature: okfw](/features/feature-okfw--01a1a8536440.md) | OKF Wiki CLI and MCP server, pinned checksum and cosign signature. |

### Data and supply-chain tools

| Concept | What it installs |
|---|---|
| [Feature: jq](/features/feature-jq--01a183800ef7.md) | jq binary. |
| [Feature: yq](/features/feature-yq--01a18380115a.md) | yq binary. |
| [Feature: grype](/features/feature-grype--01a183800ecb.md) | Grype scanner, checksums file. |
| [Feature: syft](/features/feature-syft--01a183801108.md) | Syft SBOM generator, checksums file. |
| [Feature: redis-cli](/features/feature-redis-cli--01a1bf265536.md) | `valkey-cli` with a `redis-cli` link, pinned SHA256 for each architecture. |

### Container build tools

| Concept | What it installs |
|---|---|
| [Feature: kaniko](/features/feature-kaniko--01a183800f23.md) | kaniko executor and warmer, pinned layer digests. |
| [Feature: envbuilder](/features/feature-envbuilder--01a183800e01.md) | Coder envbuilder, pinned layer digest. |

### System packages (privileged lane)

| Concept | What it installs |
|---|---|
| [Feature: git](/features/feature-git--01a183800e27.md) | The `git` RPM. |
| [Feature: git-lfs](/features/feature-git-lfs--01a183800e4e.md) | The `git-lfs` RPM. |
| [Feature: make](/features/feature-make--01a183800f4f.md) | The `make` RPM. |
| [Feature: sshd](/features/feature-sshd--01a1838010dc.md) | Hardened OpenSSH server with an entrypoint. |

### Deprecated

| Concept | What it installs |
|---|---|
| [Feature: npm](/features/feature-npm--01a183800fd2.md) | Deprecated. Use the `npm_version` option of `nodejs`. |

## Related

* [Role contract](/architecture/role-contract--01a1837fddd1.md)
* [Add a new feature](/operations/add-a-new-feature--01a1837fe116.md)
* [Change a feature and bump its version](/operations/change-a-feature-and-bump-its-version--01a1837fe143.md)
* [Wiki map](/wiki-map--01a1837af671.md)
* [Decisions overview](/decisions/decisions-overview--01a1837af6ce.md) — the ADRs that shape the features.
* [Architecture overview](/architecture/architecture-overview--01a1837af69f.md) — the runner and the role contract.
* [Supply-chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md) — how the features are staged, reviewed and promoted.
* [Issues overview](/issues/issues-overview--01a1837af732.md)
