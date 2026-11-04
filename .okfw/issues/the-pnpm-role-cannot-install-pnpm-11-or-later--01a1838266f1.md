---
id: "01a18382-66f1-7b58-8e8a-683288a33474"
title: "The pnpm role cannot install pnpm 11 or later"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "open"
  - "pnpm"
created: "2026-10-28T12:15:23-05:00"
timestamp: "2026-10-28T12:20:48-05:00"
description: "pnpm 11 and later ship a tarball with a binary and a dist/ tree, but the role installs one binary; pnpm stays on 10.x."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:48-05:00"
status: "draft"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/26"
    title: "PR #26"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/commit/c4280a1"
    title: "Commit c4280a1"
---

# The pnpm role cannot install pnpm 11 or later

The `pnpm` feature stays on the 10.x line. From pnpm 11, the release is a tarball with a binary and a `dist/` tree, and the role installs only a single binary.

## Problem

pnpm 10.x still gets security releases, but a later 10.x end of life leaves no upgrade path. A move to 11 or 12 needs a new role and is a behavior change for every consumer. pnpm 12 is a rewrite with breaking changes.

## Context

* PR #26 (2026-10-28) moved pnpm to 10.34.9, the newest 10.x release.
* Commit `c4280a1` makes `check-version-currency.sh` compare pnpm with the `latest-10` dist-tag. Thus the check does not report a newer major release.

## Acceptance criteria

- [ ] The role installs the pnpm 11 or later tarball layout.
- [ ] A decision records which major line the feature tracks.

## Related

* [Feature: pnpm](/features/feature-pnpm--01a183801056.md)
* [The kaniko role cannot install kaniko 1.29 or later](/issues/the-kaniko-role-cannot-install-kaniko-1-29-or-later--01a1838266c2.md)
* [On 2026-10-28, kaniko is the only feature pin behind upstream](/findings/on-2026-10-28-kaniko-is-the-only-feature-pin-behind-upstream--01a1838267fd.md)
* [Four containerEnv values name /home/dev](/issues/four-containerenv-values-name-home-dev--01a183826729.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
