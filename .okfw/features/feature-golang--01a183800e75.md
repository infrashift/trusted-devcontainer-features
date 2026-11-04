---
id: "01a18380-0e75-7d43-98f8-5baf4041d938"
title: "Feature: golang"
type: "feature"
tags:
  - "feature"
  - "golang"
created: "2026-10-28T12:12:50-05:00"
timestamp: "2026-10-28T12:17:21-05:00"
description: "The golang feature installs Go from go.dev in ~/.local/share/go, verified against a pinned SHA256 checksum, with GOPATH set."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:21-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/features/golang.mdx"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/golang/devcontainer-feature.json"
    title: "golang devcontainer-feature.json"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/tree/main/src/golang/ansible-role-feature"
    title: "golang Ansible role"
---

# Feature: golang

The `golang` feature installs Go from `go.dev/dl` into `~/.local/share/go`. The role verifies the tarball against a pinned SHA256 checksum. It links `go` and `gofmt` into `~/.local/bin`. `containerEnv` sets `GOPATH` to `/home/dev/.local/share/gopath`.

## Options

Feature version 1.5.4. The defaults are from `src/golang/devcontainer-feature.json` on 2026-10-28.

| Option | Default | Use |
|---|---|---|
| `target_version` | `1.27.3` | The Go version. |
| `target_checksum` | empty | Empty: use the pinned checksum. Required for a version that has no pin. |

## Dependencies

* `dependsOn`: `./bootstrap`. The runtime installs [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) first ([ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md)).
* `installsAfter`: none.

## Test templates

The test template `go-cue` in `test-templates/` uses this feature.

## Notes

* The docs page says that the role adds `~/.local/share/go/bin` and `~/.local/share/gopath/bin` to `PATH`. The code links only `go` and `gofmt` into `~/.local/bin`. Thus a binary from `go install` is not on `PATH`.

## Related

* [Four containerEnv values name /home/dev](/issues/four-containerenv-values-name-home-dev--01a183826729.md)
* [Binaries from go install are not on PATH](/issues/binaries-from-go-install-are-not-on-path--01a183894c64.md)
* [Feature: cuelang](/features/feature-cuelang--01a183800db4.md) — orders after this feature.
* [ADR-006: Checksum verification](/decisions/adr-006-checksum-verification--01a183801256.md)
* [ADR-011: dev user alignment](/decisions/adr-011-dev-user-alignment--01a183801339.md) — the literal path in `containerEnv`.
* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
