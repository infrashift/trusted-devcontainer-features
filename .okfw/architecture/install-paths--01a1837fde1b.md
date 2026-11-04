---
id: "01a1837f-de1b-78cf-9f1f-503f1c8465a6"
title: "Install paths"
type: "component"
tags:
  - "architecture"
  - "install-paths"
created: "2026-10-28T12:12:37-05:00"
timestamp: "2026-10-28T12:20:26-05:00"
description: "Userland features install below the dev user home: binaries link into ~/.local/bin, tool trees go in ~/.local/share/<tool>."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:26-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/reference/architecture.md"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/test-templates/shared/Containerfile"
    title: "Shared test Containerfile"
---

# Install paths

A userland feature installs below the home directory of the target user. The role reads the home directory from `_target_user_home`. It does not hardcode `/home/dev`.

## Paths

| Path | Content |
|---|---|
| `~/.local/bin` | Single binaries (`jq`, `yq`, `grype`, `syft`, `envbuilder`, `uv`, `ruff`) and links to tools in `~/.local/share` |
| `~/.local/share/<tool>` | Tool trees: `go`, `nodejs`, `java`, `dotnet`, `cue`, `sqlpackage` |
| `~/.local/share/maven/apache-maven-<version>` | Maven, with `mvn` linked into `~/.local/bin` |
| `~/.local/share/gradle/gradle-<version>` | Gradle, with `gradle` linked into `~/.local/bin` |
| `~/.local/share/kaniko/<version>` | kaniko executor and warmer |
| `~/.local/share/gopath` | `GOPATH` |
| `~/.local/share/pnpm` | `PNPM_HOME` |
| `~/.bun/bin` | Bun global installs: `claude` and `codex` |

Privileged features write system paths, for example `/usr/sbin/sshd` and `/usr/local/share/ssh-init.sh`.

## `PATH`

The base image puts `~/.local/bin` on `PATH`. Thus a feature links its binary into `~/.local/bin` and needs no `containerEnv` entry for `PATH`. On 2026-10-28, only `pnpm` adds a `PATH` entry in `containerEnv`.

Four variables name a location, not a binary: `DOTNET_ROOT`, `JAVA_HOME`, `GOPATH` and `PNPM_HOME`. The features set them in `containerEnv` with the literal value `/home/dev/...`. This value is not correct for a different user name. See [Dev user](/architecture/dev-user--01a1837fde35.md).

## Related

* [Four containerEnv values name /home/dev](/issues/four-containerenv-values-name-home-dev--01a183826729.md)
* [Binaries from go install are not on PATH](/issues/binaries-from-go-install-are-not-on-path--01a183894c64.md)
* [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md)
* [Feature: dotnet](/features/feature-dotnet--01a183800dda.md)
* [Feature: openjdk](/features/feature-openjdk--01a18380102a.md)
* [Feature: golang](/features/feature-golang--01a183800e75.md)
* [Feature: pnpm](/features/feature-pnpm--01a183801056.md)
* [Dev user](/architecture/dev-user--01a1837fde35.md)
* [Userland and privileged lanes](/architecture/userland-and-privileged-lanes--01a1837fddb9.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
* [Architecture overview](/architecture/architecture-overview--01a1837af69f.md)
