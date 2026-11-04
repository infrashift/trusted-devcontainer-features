---
id: "01a1837f-de02-7a00-9389-f31619e563a7"
title: "Variant detection"
type: "component"
tags:
  - "architecture"
  - "variant"
  - "fedora"
  - "ubi"
created: "2026-10-28T12:12:37-05:00"
timestamp: "2026-10-28T12:20:26-05:00"
description: "The bootstrap feature reads /etc/os-release once and writes the variant (fedora43, ubi9, ubi10) to the inventory; each role asserts it."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:26-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/bootstrap/install.sh"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/decisions/adr-010-fedora-target.md"
    title: "ADR-010"
---

# Variant detection

The `bootstrap` feature detects the container variant one time, from `/etc/os-release`. It writes the result to `/opt/bootstrap/inventory.yml` as the group variable `_securedevcontainer_variant`.

## The rule in `src/bootstrap/install.sh`

| `ID` in `/etc/os-release` | Variant |
|---|---|
| `rhel` (UBI images) | `ubi<major>` |
| `fedora` | `fedora<major>` |
| other | `<ID><major>` |

`<major>` is the part of `VERSION_ID` before the first dot.

## The assert in each role

`vars/main.yml` of each role holds `_securedevcontainer_compatibility_list`. The first task of the role asserts that the variant is in that list. On 2026-10-28, all 26 roles list `ubi9`, `ubi10` and `fedora43`. `make check-contract` fails when a role has no variant assert.

## Why

Before this design, each feature had a `hosts.yml` that put `localhost` in the group `ubi9`. The assert compared `"ubi9"` with `["ubi9","ubi10"]` and passed on all images.

## Analysis

The test templates and the maintainer dev container use `fedora43-minimal` only (ADR-010). No CI job builds a UBI image, so the `ubi9` and `ubi10` entries have no test.

## Related

* [ADR-001: UBI 9 base image](/decisions/adr-001-ubi-9-base-image--01a183801183.md)
* [ADR-010: Fedora 43 target](/decisions/adr-010-fedora-43-target--01a183801309.md)
* [Bootstrap environment](/architecture/bootstrap-environment--01a1837fdda1.md)
* [Role contract](/architecture/role-contract--01a1837fddd1.md)
* [Test templates](/architecture/test-templates--01a1837fde68.md)
* [Decisions overview](/decisions/decisions-overview--01a1837af6ce.md) — ADR-001 and ADR-010.
* [Architecture overview](/architecture/architecture-overview--01a1837af69f.md)
