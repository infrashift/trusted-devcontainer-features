---
id: "01a18382-6729-79cd-bf86-d2f65b90ff8f"
title: "Four containerEnv values name /home/dev"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "open"
  - "golang"
  - "openjdk"
  - "dotnet"
  - "pnpm"
  - "dev-user"
created: "2026-10-28T12:15:23-05:00"
timestamp: "2026-10-28T12:20:48-05:00"
description: "golang, openjdk, dotnet and pnpm set GOPATH, JAVA_HOME, DOTNET_ROOT and PNPM_HOME to /home/dev paths, which are wrong for other accounts."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:48-05:00"
status: "draft"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/20"
    title: "PR #20"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/dotnet/devcontainer-feature.json"
    title: "src/dotnet/devcontainer-feature.json"
---

# Four containerEnv values name /home/dev

Four features set a `containerEnv` value to a path under `/home/dev`. Under another account, for example `user` in the trusted seeds, the value names a directory that does not exist.

## Problem

| Feature | Variable | Value |
|---|---|---|
| `golang` | `GOPATH` | `/home/dev/.local/share/gopath` |
| `openjdk` | `JAVA_HOME` | `/home/dev/.local/share/java` |
| `dotnet` | `DOTNET_ROOT` | `/home/dev/.local/share/dotnet` |
| `pnpm` | `PNPM_HOME`, `PATH` | `/home/dev/.local/share/pnpm` |

A tool that reads one of these variables fails under another account. [The sqlpackage feature could not find the .NET runtime](/issues/the-sqlpackage-feature-could-not-find-the-net-runtime--01a183826142.md) was this failure.

## Context

* PR #20 (2026-09-16) left the four values on purpose. They name a location, not a binary, so a link in `~/.local/bin` cannot replace them.
* `${containerEnv:HOME}` does not work: the CLI writes `containerEnv` into a Dockerfile `ENV`, which rejects the `:H` modifier.
* The `dotnet-node` template runs as `user` 1001:0, so its tests show if a tool needs one of these values.

## Acceptance criteria

- [ ] Each of the four variables is correct under any account, or each feature documents the limit for the consumer.

## Related

* [Install paths](/architecture/install-paths--01a1837fde1b.md)
* [Feature: pnpm](/features/feature-pnpm--01a183801056.md)
* [Feature: dotnet](/features/feature-dotnet--01a183800dda.md)
* [Feature: openjdk](/features/feature-openjdk--01a18380102a.md)
* [Feature: golang](/features/feature-golang--01a183800e75.md)
* [Feature: sqlpackage](/features/feature-sqlpackage--01a1838010af.md)
* [The test templates used an account that no seed uses](/issues/the-test-templates-used-an-account-that-no-seed-uses--01a18382611a.md)
* [The sqlpackage feature could not find the .NET runtime](/issues/the-sqlpackage-feature-could-not-find-the-net-runtime--01a183826142.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
