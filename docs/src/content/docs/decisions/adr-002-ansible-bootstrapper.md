---
title: "ADR-002: Ansible as Feature Bootstrapper"
description: Decision to use Ansible playbooks as the installation mechanism for features.
---

**Status:** Accepted

## Context

Each Dev Container Feature requires an `install.sh` script that runs as root during container build. These scripts typically contain imperative shell commands for downloading, verifying, extracting, and configuring tools. As the feature count grew, shell scripts became difficult to maintain, test, and keep consistent.

We needed a mechanism that provides idempotency, structured variable handling, and reusable task patterns across features.

## Decision

Use Ansible playbooks as the installation mechanism. Each feature's `install.sh` is a thin wrapper that invokes `ansible-playbook` with feature-specific variables. The actual installation logic lives in `activate-feature.yml` playbooks with structured tasks.

## Consequences

- **Positive**: Ansible provides idempotent operations, structured error handling, and built-in modules for downloading files, managing packages, and templating configuration.
- **Positive**: Consistent pattern across all 20 features — each install.sh has the same structure.
- **Positive**: Easier to audit and review YAML-based playbooks compared to complex shell scripts.
- **Negative**: Adds a dependency on ansible-core being available at install time (solved by ADR-004: UV as Ansible Runner).
- **Negative**: Slightly higher overhead per feature install due to Ansible startup time.

## Alternatives Considered

- **Pure shell scripts**: The original approach. Rejected due to growing maintenance burden and inconsistency across features.
- **Make-based installation**: Rejected. Make doesn't provide idempotency or structured variable handling.
- **Container-native multi-stage builds**: Rejected. The Dev Container Feature spec requires install.sh as the entry point.
