---
id: "01a18382-6669-7457-9f4d-efbe3034442b"
title: "Role compatibility lists name UBI variants that CI does not test"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "open"
  - "testing"
  - "ubi"
created: "2026-10-28T12:15:23-05:00"
timestamp: "2026-10-28T12:20:48-05:00"
description: "All 26 roles list ubi9 and ubi10 as tested variants, but CI builds every test template on Fedora 43 minimal only."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:48-05:00"
status: "draft"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/decisions/adr-010-fedora-target.md"
    title: "docs/src/content/docs/decisions/adr-010-fedora-target.md"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/jq/ansible-role-feature/vars/main.yml"
    title: "src/jq/ansible-role-feature/vars/main.yml"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/test-templates/shared/Containerfile"
---

# Role compatibility lists name UBI variants that CI does not test

Each of the 26 roles lists `ubi9`, `ubi10` and `fedora43` in `_securedevcontainer_compatibility_list`. CI builds every test template on Fedora 43 minimal only.

## Problem

ADR-010 says: "Each role's `vars/main.yml` lists the variants it has actually been tested against." No test template uses a UBI image. Thus the role assert accepts `ubi9` and `ubi10` without a test that shows that the role works there.

## Context

* `bootstrap` maps `ID=rhel` to `ubi<major>` in `/opt/bootstrap/inventory.yml`, so a UBI image passes the assert.
* All test templates build from `test-templates/shared/Containerfile`, which starts `FROM` `trusted/fedora43-minimal`.
* `docs/src/content/docs/reference/contributing.md` lines 82 to 86 tell contributors to list all three variants.
* The roadmap plans a UBI 10 test matrix. See [Roadmap](/plans/roadmap--01a1838268b5.md).

## Acceptance criteria

- [ ] Either CI builds at least one test template on a UBI 9 or UBI 10 image,
- [ ] or the roles and `contributing.md` remove the variants that CI does not test.

## Related

* [ADR-010: Fedora 43 target](/decisions/adr-010-fedora-43-target--01a183801309.md)
* [ADR-001: UBI 9 base image](/decisions/adr-001-ubi-9-base-image--01a183801183.md)
* [The docs site says the features target UBI 9](/issues/the-docs-site-says-the-features-target-ubi-9--01a18382654c.md)
* [Roadmap](/plans/roadmap--01a1838268b5.md)
* [Architecture overview](/architecture/architecture-overview--01a1837af69f.md)
* [Decisions overview](/decisions/decisions-overview--01a1837af6ce.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
