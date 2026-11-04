---
id: "01a18389-4bf8-7a8e-a678-b4d6e2e68c36"
title: "Several ADRs state facts that the code no longer has"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "open"
  - "docs"
  - "decision"
created: "2026-10-28T12:22:55-05:00"
timestamp: "2026-10-28T12:24:37-05:00"
description: "ADR-002, 006, 008, 009, 010, 011 and 012 give old counts, defaults, feature names and mechanisms that the code changed."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:24:37-05:00"
status: "draft"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/decisions"
    title: "ADR directory"
---

# Several ADRs state facts that the code no longer has

Four ADRs state a current fact in the present tense that the code changed later. A reader who trusts the ADR gets a wrong default, a wrong list or a wrong mechanism.

## Problem

* ADR-008 lines 23–24 give the `bootstrap` defaults Python 3.12 and ansible-core 2.18.2. `src/bootstrap/devcontainer-feature.json` has 3.14 and 2.21.3.
* ADR-009 line 39 says that the relative `./bootstrap` reference works after publication. It does not. `scripts/rewrite-feature-refs.sh` rewrites it to `ghcr.io/<repo>/bootstrap@<digest>` at publication time.
* ADR-012 line 42 says that the privileged lane is "currently `git` and `git-lfs`". `make` and `sshd` also pass `--privileged`.
* ADR-012 line 97 calls `dotnet` "the lone SHA512". `maven` also takes a SHA512 checksum (`src/maven/ansible-role-feature/tasks/main.yml` line 36).
* ADR-006 line 16 says that `yq` uses the checksums file of the release. The `yq` role has a pinned checksum map, `_yq_pinned_checksums`.

## Context

Some ADRs give feature counts ("20 features", "21 features") and the feature names `sudo` and `egress-filter`. These describe the state on the date of each ADR. They are history, not errors. This issue is only about the present-tense claims above.

## Acceptance criteria

- [ ] Each claim above is correct, or it has a dated note that says what changed.
- [ ] The ADRs point to the source file for a value that changes, not a copy of the value.

## Related

* [ADR-006: Checksum verification](/decisions/adr-006-checksum-verification--01a183801256.md)
* [ADR-008: Pinned bootstrap environment](/decisions/adr-008-pinned-bootstrap-environment--01a1838012ac.md)
* [ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md)
* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md)
* [Userland and privileged lanes](/architecture/userland-and-privileged-lanes--01a1837fddb9.md)
* [The architecture page disagrees with the code](/issues/the-architecture-page-disagrees-with-the-code--01a183826585.md)
* [Bring the docs site in line with the code](/plans/bring-the-docs-site-in-line-with-the-code--01a1838268e3.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
