---
id: "01a18380-11ad-7801-a40c-63523322af12"
title: "ADR-002: Ansible as the feature installer"
type: "decision"
tags:
  - "decision"
  - "adr-002"
  - "ansible"
  - "role"
created: "2026-10-28T12:12:50-05:00"
timestamp: "2026-10-28T12:17:22-05:00"
description: "Accepted: an Ansible role does the installation of each feature, and install.sh is only a thin wrapper."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:22-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/decisions/adr-002-ansible-bootstrapper.md"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/bootstrap/assets/site.yml"
    title: "Generic site.yml"
---

# ADR-002: Ansible as the feature installer

ADR-002 makes Ansible the installation mechanism of every feature. `install.sh` is a thin wrapper, and the installation logic is in Ansible tasks.

**Status:** Accepted. [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md) changes how the wrapper calls Ansible. The choice of Ansible does not change.

## Decision

Use Ansible for the installation, because it gives idempotent tasks, structured variables and modules for downloads and packages. The ADR first put the logic in one `activate-feature.yml` playbook for each feature. The cost is that `ansible-core` must be present at install time ([ADR-004: uv as the Ansible runner](/decisions/adr-004-uv-as-the-ansible-runner--01a183801200.md), then [ADR-008: Pinned bootstrap environment](/decisions/adr-008-pinned-bootstrap-environment--01a1838012ac.md)).

## Code check on 2026-10-28

The code agrees with the choice of Ansible. It does not have the original file layout: no `activate-feature.yml` exists. Each `install.sh` runs `/opt/bootstrap/run-feature.sh --role ansible-role-feature`, and `src/<name>/ansible-role-feature/` holds the role ([ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md)). The ADR says "all 20 features". The repository has 27 features.

## Features affected

All features. [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) supplies the Ansible environment.

## Related

* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md) — the current wrapper and role shape.
* [ADR-008: Pinned bootstrap environment](/decisions/adr-008-pinned-bootstrap-environment--01a1838012ac.md) — where `ansible-core` comes from.
* [Architecture overview](/architecture/architecture-overview--01a1837af69f.md)
* [Decisions overview](/decisions/decisions-overview--01a1837af6ce.md)
