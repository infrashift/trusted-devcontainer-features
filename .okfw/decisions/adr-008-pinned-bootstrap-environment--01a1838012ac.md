---
id: "01a18380-12ac-7630-a93d-17c5efb0694b"
title: "ADR-008: Pinned bootstrap environment"
type: "decision"
tags:
  - "decision"
  - "adr-008"
  - "bootstrap"
  - "uv"
  - "ansible"
created: "2026-10-28T12:12:51-05:00"
timestamp: "2026-10-28T12:17:22-05:00"
description: "Accepted: the bootstrap feature installs pinned, checksum-verified uv, CPython and ansible-core in a root-owned /opt/bootstrap. Supersedes ADR-004."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:22-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/decisions/adr-008-pinned-bootstrap-environment.md"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/bootstrap/install.sh"
    title: "bootstrap install.sh"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/bootstrap/devcontainer-feature.json"
    title: "bootstrap devcontainer-feature.json"
---

# ADR-008: Pinned bootstrap environment

ADR-008 replaces `uv run --with ansible-core` with a permanent, pinned environment in `/opt/bootstrap`. The `bootstrap` feature installs it.

**Status:** Accepted. Supersedes [ADR-004: uv as the Ansible runner](/decisions/adr-004-uv-as-the-ansible-runner--01a183801200.md).

## Decision

`bootstrap` installs uv from a pinned release tarball and verifies its SHA256 checksum. It makes the venv `/opt/bootstrap/.bootstrap` on a uv-managed CPython (option `python_version`) with a pinned `ansible-core` (option `ansible_core_version`). The inventory sets `ansible_python_interpreter` to the venv Python. `UV_PYTHON_INSTALL_DIR` is `/opt/bootstrap/python`, so the dev user can read it. The whole tree is root-owned and world-readable, so the dev user cannot change the toolchain.

## Code check on 2026-10-28

The code agrees with the design. The ADR gives the defaults Python 3.12 and `ansible-core` 2.18.2. The defaults in `src/bootstrap/devcontainer-feature.json` are now 3.14 and 2.21.3. For a uv version that is not the default, `install.sh` uses the `.sha256` file of the release.

## Features affected

[Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) directly. All other features run through its runner.

## Related

* [Several ADRs state facts that the code no longer has](/issues/several-adrs-state-facts-that-the-code-no-longer-has--01a183894bf8.md)
* [Bootstrap environment](/architecture/bootstrap-environment--01a1837fdda1.md)
* [ADR-004: uv as the Ansible runner](/decisions/adr-004-uv-as-the-ansible-runner--01a183801200.md) — the superseded runner.
* [ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md) — makes `bootstrap` mandatory.
* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md) — the runner interface.
* [ADR-010: Fedora 43 target](/decisions/adr-010-fedora-43-target--01a183801309.md) — the variant detection in the same `install.sh`.
* [Architecture overview](/architecture/architecture-overview--01a1837af69f.md)
* [Decisions overview](/decisions/decisions-overview--01a1837af6ce.md)
