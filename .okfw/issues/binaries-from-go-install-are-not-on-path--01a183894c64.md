---
id: "01a18389-4c64-7463-bd4f-5e39767d8b1d"
title: "Binaries from go install are not on PATH"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "open"
  - "golang"
created: "2026-10-28T12:22:55-05:00"
timestamp: "2026-10-28T12:24:37-05:00"
description: "The golang feature sets GOPATH but does not put \\$GOPATH/bin on PATH, so a tool from go install is not found by name."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:24:37-05:00"
status: "draft"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/golang/ansible-role-feature/tasks/main.yml"
    title: "golang role tasks"
---

# Binaries from go install are not on PATH

The `golang` feature sets `GOPATH` to `/home/dev/.local/share/gopath`, but nothing adds `$GOPATH/bin` to PATH. A tool that a user installs with `go install` is not found by its name.

## Problem

* `src/golang/devcontainer-feature.json` sets only `GOPATH` in `containerEnv`.
* The role links `go` and `gofmt` into `~/.local/bin` (`tasks/main.yml` line 149). It does not link `$GOPATH/bin`, because that directory does not exist at install time (line 142).
* Thus `go install golang.org/x/tools/gopls@latest` succeeds, but `gopls` is not on PATH.

## Context

The docs page `golang.mdx` says that the role adds a directory to PATH. That statement hides the problem. The `/home/dev` value in `containerEnv` is also a separate issue.

## Acceptance criteria

- [ ] After `go install <tool>@<version>`, the tool runs by name in a new shell as the dev user.
- [ ] A smoke test in the `go-cue` test template checks this.

## Related

* [Feature: golang](/features/feature-golang--01a183800e75.md)
* [Install paths](/architecture/install-paths--01a1837fde1b.md)
* [Four containerEnv values name /home/dev](/issues/four-containerenv-values-name-home-dev--01a183826729.md)
* [Feature docs pages disagree with the code](/issues/feature-docs-pages-disagree-with-the-code--01a183894c2e.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
