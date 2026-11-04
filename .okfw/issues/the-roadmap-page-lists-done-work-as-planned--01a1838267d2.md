---
id: "01a18382-67d2-7a43-9879-dc395c5ef421"
title: "The roadmap page lists done work as planned"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "open"
  - "docs"
  - "roadmap"
created: "2026-10-28T12:15:23-05:00"
timestamp: "2026-10-28T12:20:48-05:00"
description: "roadmap.md still plans ARM64 support and a UBI 9 and UBI 10 matrix, but CI tests arm64 and the base is Fedora 43."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:48-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/reference/roadmap.md"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/10"
    title: "PR #10"
---

# The roadmap page lists done work as planned

`docs/src/content/docs/reference/roadmap.md` plans work that is already done, and plans a platform matrix that the code no longer uses.

## Problem

* The "ARM64 (aarch64) Support" item says that many features support only x86_64. Since PR #10 (2026-08-24), CI builds each selected test template on amd64 and arm64.
* The "UBI 10 Support" item plans a matrix on UBI 9 and UBI 10. CI tests on Fedora 43 minimal only.
* The "Supply Chain Attestations" item does not say that the release already signs each feature with cosign.

## Context

* `scripts/compute-test-matrix.sh` makes one entry for each template on `ubuntu-latest` (amd64) and `ubuntu-24.04-arm` (arm64).
* [Roadmap](/plans/roadmap--01a1838268b5.md) gives the state of each item on 2026-10-28.

## Acceptance criteria

- [ ] The roadmap page removes or marks the done items.
- [ ] The platform items name Fedora 43 as the tested base.

## Related

* [Roadmap](/plans/roadmap--01a1838268b5.md)
* [The docs site says the features target UBI 9](/issues/the-docs-site-says-the-features-target-ubi-9--01a18382654c.md)
* [Bring the docs site in line with the code](/plans/bring-the-docs-site-in-line-with-the-code--01a1838268e3.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
