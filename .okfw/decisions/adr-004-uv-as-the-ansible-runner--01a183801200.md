---
id: "01a18380-1200-7c63-b9ff-6a0d886df899"
title: "ADR-004: uv as the Ansible runner"
type: "decision"
tags:
  - "decision"
  - "adr-004"
  - "uv"
  - "bootstrap"
  - "superseded"
created: "2026-10-28T12:12:50-05:00"
timestamp: "2026-10-28T12:17:22-05:00"
description: "Superseded by ADR-008: each install.sh ran Ansible with uv run --with ansible-core in a temporary environment."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:22-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/decisions/adr-004-uv-as-ansible-runner.md"
---

# ADR-004: uv as the Ansible runner

ADR-004 ran Ansible with `uv run --with ansible-core ansible-playbook` in each `install.sh`. uv made a temporary environment, installed `ansible-core`, ran the playbook and removed the environment. The base Containerfile installed uv.

**Status:** Superseded by [ADR-008: Pinned bootstrap environment](/decisions/adr-008-pinned-bootstrap-environment--01a1838012ac.md).

## Decision

Do not install `ansible-core` permanently. Install uv in the base image and get `ansible-core` from PyPI for each feature install.

## Why it was superseded

[ADR-008: Pinned bootstrap environment](/decisions/adr-008-pinned-bootstrap-environment--01a1838012ac.md) gives three reasons. `fedora43-minimal` has no `python3`. `--with ansible-core` is not pinned, so two builds of one commit can get different Ansible versions. Each feature paid the resolution cost again.

## Code check on 2026-10-28

No `uv run --with` remains in `src/` or `scripts/`. [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) supplies a pinned environment.

## Related

* [ADR-008: Pinned bootstrap environment](/decisions/adr-008-pinned-bootstrap-environment--01a1838012ac.md) — the replacement.
* [ADR-002: Ansible as the feature installer](/decisions/adr-002-ansible-as-the-feature-installer--01a1838011ad.md) — the decision that needed a runner.
* [Decisions overview](/decisions/decisions-overview--01a1837af6ce.md)
