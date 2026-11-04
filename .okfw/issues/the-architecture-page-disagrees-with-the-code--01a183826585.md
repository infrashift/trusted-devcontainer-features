---
id: "01a18382-6585-7397-adfd-26745a7e1f2c"
title: "The architecture page disagrees with the code"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "open"
  - "docs"
created: "2026-10-28T12:15:23-05:00"
timestamp: "2026-10-28T12:20:47-05:00"
description: "architecture.md names only git and git-lfs as privileged and says defaults/main.yml holds versions; the code has four privileged features and empty defaults."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:47-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/reference/architecture.md"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/decisions/adr-012-feature-role-contract.md"
    title: "docs/src/content/docs/decisions/adr-012-feature-role-contract.md"
---

# The architecture page disagrees with the code

`docs/src/content/docs/reference/architecture.md` states two facts that the code does not support, and it omits the release pipeline.

## Problem

* Line 70 says that the privileged lane is for `git` and `git-lfs`. Four features pass `--privileged` in `install.sh`: `git`, `git-lfs`, `make` and `sshd`.
* Line 109 says that `defaults/main.yml` holds "versions, URLs, pinned checksums". Every `defaults/main.yml` in `src/` holds only comments. The pinned checksums are in `vars/main.yml`. ADR-012 and `make check-contract` require empty defaults.
* The "CI/CD Pipeline" section (line 167) describes only `test-templates.yaml`. It does not mention `pr-gate.yml` or `release.yaml`.

## Context

* ADR-012 line 42 also says that the privileged lane is "currently `git` and `git-lfs`".
* `README.md` line 89 states the empty-defaults rule correctly.

## Acceptance criteria

- [ ] The privileged lane text names all features that pass `--privileged`, or names none.
- [ ] The directory layout says that `vars/main.yml` holds the derived values and pinned checksums.
- [ ] The CI/CD section names the PR gate and the release workflow.

## Related

* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md)
* [Userland and privileged lanes](/architecture/userland-and-privileged-lanes--01a1837fddb9.md)
* [The docs site does not describe the release pipeline or signature checks](/issues/the-docs-site-does-not-describe-the-release-pipeline-or-signature-checks--01a1838265c1.md)
* [Workspace images had no make](/issues/workspace-images-had-no-make--01a183826263.md)
* [Bring the docs site in line with the code](/plans/bring-the-docs-site-in-line-with-the-code--01a1838268e3.md)
* [Architecture overview](/architecture/architecture-overview--01a1837af69f.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
