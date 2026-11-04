---
id: "01a18380-1183-7de6-b8d9-aa048577966d"
title: "ADR-001: UBI 9 base image"
type: "decision"
tags:
  - "decision"
  - "adr-001"
  - "base-image"
  - "superseded"
created: "2026-10-28T12:12:50-05:00"
timestamp: "2026-10-28T12:17:22-05:00"
description: "Superseded by ADR-010: the features targeted Red Hat UBI 9 only, with dnf and the UBI repositories."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:22-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/decisions/adr-001-ubi-image-support.md"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/test-templates/shared/Containerfile"
    title: "Shared test Containerfile"
---

# ADR-001: UBI 9 base image

ADR-001 made Red Hat UBI 9 the only target of the features. All features used `dnf`, the RHEL file system layout and the UBI repositories. The tests used `registry.access.redhat.com/ubi9/ubi:latest`.

**Status:** Superseded by [ADR-010: Fedora 43 target](/decisions/adr-010-fedora-43-target--01a183801309.md).

## Decision

Target UBI 9 only. Do not support Debian, Ubuntu or Alpine, because each feature would need OS detection and a second test matrix.

## Code check on 2026-10-28

The code no longer follows this ADR. The shared test Containerfile `test-templates/shared/Containerfile` starts from `fedora43-minimal`. Each role lists `ubi9`, `ubi10` and `fedora43` as compatible variants. The `description` of most features still says "on Red Hat UBI DevContainers".

## Features affected

All features. See the [Features overview](/features/features-overview--01a1837af6b6.md).

## Related

* [The docs site says the features target UBI 9](/issues/the-docs-site-says-the-features-target-ubi-9--01a18382654c.md)
* [Role compatibility lists name UBI variants that CI does not test](/issues/role-compatibility-lists-name-ubi-variants-that-ci-does-not-test--01a183826669.md)
* [ADR-010: Fedora 43 target](/decisions/adr-010-fedora-43-target--01a183801309.md) — the replacement.
* [Architecture overview](/architecture/architecture-overview--01a1837af69f.md)
* [Decisions overview](/decisions/decisions-overview--01a1837af6ce.md)
