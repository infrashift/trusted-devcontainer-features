---
id: "01a18382-66c2-7e9a-b9d8-946dc65542fa"
title: "The kaniko role cannot install kaniko 1.29 or later"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "open"
  - "kaniko"
created: "2026-10-28T12:15:23-05:00"
timestamp: "2026-10-28T12:20:48-05:00"
description: "In kaniko 1.29.0 the executor is a hard link to a multi-call binary, which the role cannot extract or install by name."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:48-05:00"
status: "draft"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/commit/9f9ce19"
    title: "Commit 9f9ce19"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/kaniko/ansible-role-feature/tasks/main.yml"
---

# The kaniko role cannot install kaniko 1.29 or later

The `kaniko` feature stays on 1.28.6. The role cannot install kaniko 1.29.0, which is the newest release on 2026-10-28.

## Problem

In kaniko 1.29.0, the executor layer has one binary, `docker-credential-acr-env`. `kaniko/executor` is a hard link to it. The warmer layer has the same structure. The role extracts only `kaniko/executor`, so `gtar` fails because the link target is not extracted. The binary also selects its function from `argv[0]`, and the role installs it as `kaniko-executor` and `kaniko-warmer`.

## Context

* Commit `9f9ce19` (PR #25, 2026-10-28) records the failure on both architectures in the `infra` template.
* kaniko 1.29 also turns on about thirty feature flags. They invalidate existing caches and change reproducible-build digests.
* `make check-currency` reports `kaniko` as behind.

## Acceptance criteria

- [ ] The role installs the 1.29 multi-call binary with names that it answers to.
- [ ] The `infra` template passes on amd64 and arm64 with kaniko 1.29 or later.
- [ ] The change records the effect of the new feature flags.

## Related

* [Feature: kaniko](/features/feature-kaniko--01a183800f23.md)
* [On 2026-10-28, kaniko is the only feature pin behind upstream](/findings/on-2026-10-28-kaniko-is-the-only-feature-pin-behind-upstream--01a1838267fd.md)
* [The pnpm role cannot install pnpm 11 or later](/issues/the-pnpm-role-cannot-install-pnpm-11-or-later--01a1838266f1.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
