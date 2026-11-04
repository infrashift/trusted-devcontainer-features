---
id: "01a18382-61cb-754c-9c46-752f4960fe55"
title: "uv 0.12.5 installed CPython 3.14.7, which has two CVEs"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "resolved"
  - "cve"
  - "bootstrap"
  - "uv-ruff"
created: "2026-10-28T12:15:22-05:00"
timestamp: "2026-10-28T12:20:56-05:00"
description: "The pinned uv resolved 3.14 to 3.14.7, with CVE-2026-19445 and CVE-2026-19553; PR #24 pins uv 0.12.24, which resolves 3.14.8."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:56-05:00"
status: "deprecated"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/pull/24"
    title: "PR #24"
---

# uv 0.12.5 installed CPython 3.14.7, which has two CVEs

CVE-2026-19445 (Critical) and CVE-2026-19553 (High) are fixed in CPython 3.14.8. The pinned uv 0.12.5 resolved `3.14` to 3.14.7.

## Problem

Every template had 3.14.7 at `/opt/bootstrap/python/cpython-3.14.7`. Thus `review/cve-policy` failed every template change. The userland interpreter of the `python` feature, from the uv of `uv-ruff`, was also 3.14.7.

## Context

* Both interpreters ask for `3.14`. The pinned uv picks the patch release from its own download list.
* uv 0.12.22 and later offer 3.14.8.
* PR #24 depended on PR #23, so that the release did not move old version tags.

## Acceptance criteria

- [x] `bootstrap` and `uv-ruff` pin a uv that resolves CPython 3.14.8.
- [x] grype finds no match for either CVE.

## Resolution

* Date: 2026-10-09. PR #24 (merge `944b438`).
* `bootstrap` `uv_version` and `uv-ruff` `target_uv_version` changed from 0.12.5 to 0.12.24, with pinned checksums. `bootstrap` moved to 1.6.1, and the 25 other dependents got a patch bump.
* grype 0.117.0 found 0 matches for either CVE. Two Medium findings stay. Only CPython 3.15 pre-releases fix them.

## Related

* [Feature: python](/features/feature-python--01a183801082.md)
* [Feature: uv-ruff](/features/feature-uv-ruff--01a183801130.md)
* [CPython 3.13 had CVE-2026-82049 with no fix on its line](/issues/cpython-3-13-had-cve-2026-82049-with-no-fix-on-its-line--01a183826199.md)
* [Promotion moved old version tags onto the newest build](/issues/promotion-moved-old-version-tags-onto-the-newest-build--01a1838260cd.md)
* [The currency check skips the bootstrap, ruff and sqlpackage pins](/issues/the-currency-check-skips-the-bootstrap-ruff-and-sqlpackage-pins--01a183826696.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
