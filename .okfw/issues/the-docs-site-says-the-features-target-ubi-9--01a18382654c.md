---
id: "01a18382-654c-7e5e-8b9a-d9a0f199f2aa"
title: "The docs site says the features target UBI 9"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "open"
  - "docs"
  - "ubi"
created: "2026-10-28T12:15:23-05:00"
timestamp: "2026-10-28T12:20:47-05:00"
description: "The docs home page and 26 feature descriptions name Red Hat UBI, but every test template builds on Fedora 43 minimal."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:47-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/index.mdx"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/test-templates/shared/Containerfile"
    title: "test-templates/shared/Containerfile"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/decisions/adr-010-fedora-target.md"
    title: "docs/src/content/docs/decisions/adr-010-fedora-target.md"
---

# The docs site says the features target UBI 9

The docs site home page and the feature descriptions say that the features are for Red Hat UBI. The code builds and tests every feature on Fedora 43 minimal.

## Problem

A reader expects UBI 9 support that CI does not test. The text that is wrong:

* `docs/src/content/docs/index.mdx` line 24: "Every feature is built and tested on Red Hat Universal Base Image 9."
* `index.mdx` lines 3, 6 and 23 say "Red Hat UBI". Lines 6 and 20 say "25" features. `src/` has 27 features, including `bootstrap`.
* The `description` of 26 features in `src/<name>/devcontainer-feature.json` names "Red Hat UBI DevContainers". Only `bootstrap` does not.
* All 27 pages in `docs/src/content/docs/features/` name UBI.

## Context

* `test-templates/shared/Containerfile` and `.devcontainer/Containerfile` build from `trusted/fedora43-minimal`.
* ADR-010 makes Fedora 43 the target alongside UBI. ADR-001 (UBI 9 only) is superseded.
* `README.md` line 3 and `getting-started.md` line 10 name both Fedora 43 and UBI. That is closer to the code.
* A change to a `description` changes the published bytes, so each feature version must change too.

## Acceptance criteria

- [ ] `index.mdx` names Fedora 43 as the tested base and gives the correct feature count.
- [ ] Each feature `description` names the tested base, or names no base.

## Related

* [ADR-010: Fedora 43 target](/decisions/adr-010-fedora-43-target--01a183801309.md)
* [ADR-001: UBI 9 base image](/decisions/adr-001-ubi-9-base-image--01a183801183.md)
* [Role compatibility lists name UBI variants that CI does not test](/issues/role-compatibility-lists-name-ubi-variants-that-ci-does-not-test--01a183826669.md)
* [The roadmap page lists done work as planned](/issues/the-roadmap-page-lists-done-work-as-planned--01a1838267d2.md)
* [Bring the docs site in line with the code](/plans/bring-the-docs-site-in-line-with-the-code--01a1838268e3.md)
* [Decisions overview](/decisions/decisions-overview--01a1837af6ce.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
