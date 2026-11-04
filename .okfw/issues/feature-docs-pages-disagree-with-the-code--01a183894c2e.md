---
id: "01a18389-4c2e-78ac-a756-4a7103459c83"
title: "Feature docs pages disagree with the code"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "open"
  - "docs"
  - "feature"
created: "2026-10-28T12:22:55-05:00"
timestamp: "2026-10-28T12:24:37-05:00"
description: "Eleven feature pages give an old install method, PATH handling or dependency wording, and bootstrap has no docs page."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:24:37-05:00"
status: "draft"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/features"
    title: "Feature docs pages"
---

# Feature docs pages disagree with the code

Eleven pages in `docs/src/content/docs/features/` describe an install method, a PATH change or a dependency that the code does not have. The `bootstrap` feature has no page.

## Problem

* `git.mdx` says that the feature compiles Git from source. `git-lfs.mdx` says that it downloads a tarball. Both install an RPM through the shared `install-packages.yml` task.
* `nodejs.mdx` says to add the `npm` feature for a different npm, and names a `.tar.xz` file and a pinned digest. The code uses the `npm_version` option, a `.tar.gz` file and `SHASUMS256.txt`.
* `npm.mdx` has no deprecation note. It says that `npm` declares `nodejs` as a dependency, but `nodejs` is only in `installsAfter`.
* `sshd.mdx` says that only `git` and `git-lfs` are privileged. `make` is also privileged.
* `claude-code.mdx` and `openai-codex.mdx` say that Bun adds `~/.bun/bin` to PATH. The roles link the binaries into `~/.local/bin`.
* `bun.mdx` says "tarball". The code downloads a zip file.
* `dotnet.mdx` and `golang.mdx` say that the role adds a directory to PATH. The roles link the binaries into `~/.local/bin`.
* The pages for `ansible-core`, `python`, `cuelang` and `pnpm` say that `installsAfter` installs the other feature. `installsAfter` sets only the order.
* `bootstrap` has no page and no entry in `docs/src/data/features.json`.

## Context

Each feature concept in this wiki gives the code's fact and a "Notes" section with the difference. The code is the source of truth.

## Acceptance criteria

- [ ] Each page above agrees with `src/<name>/`.
- [ ] `bootstrap` has a docs page.

## Related

* [Feature: git](/features/feature-git--01a183800e27.md)
* [Feature: git-lfs](/features/feature-git-lfs--01a183800e4e.md)
* [Feature: nodejs](/features/feature-nodejs--01a183800fa6.md)
* [Feature: npm](/features/feature-npm--01a183800fd2.md)
* [Feature: sshd](/features/feature-sshd--01a1838010dc.md)
* [Feature: claude-code](/features/feature-claude-code--01a183800d91.md)
* [Feature: openai-codex](/features/feature-openai-codex--01a183800ffe.md)
* [Feature: bun](/features/feature-bun--01a183800d6f.md)
* [Feature: dotnet](/features/feature-dotnet--01a183800dda.md)
* [Feature: golang](/features/feature-golang--01a183800e75.md)
* [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md)
* [The README and the npm page do not say that npm is deprecated](/issues/the-readme-and-the-npm-page-do-not-say-that-npm-is-deprecated--01a183826637.md)
* [Bring the docs site in line with the code](/plans/bring-the-docs-site-in-line-with-the-code--01a1838268e3.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
