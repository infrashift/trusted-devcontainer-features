---
title: "ADR-001: UBI Image Support"
description: Decision to target Red Hat UBI 9 as the exclusive base image.
---

**Status:** Superseded by [ADR-010](/trusted-devcontainer-features/decisions/adr-010-fedora-target/)

## Context

Dev Container Features in the ecosystem typically target Debian/Ubuntu-based images. Our organization standardizes on Red Hat Universal Base Image (UBI) for compliance, support, and enterprise compatibility. UBI images use `dnf` instead of `apt`, have a different package ecosystem, and follow Red Hat's security patching cadence.

Attempting to support both Debian and UBI in a single feature set would double the testing matrix and introduce conditional logic throughout every install script.

## Decision

Target Red Hat UBI 9 exclusively. All features assume `dnf` as the package manager, RHEL-compatible filesystem layouts, and the UBI package repositories. Features are tested against `registry.access.redhat.com/ubi9/ubi:latest`.

## Consequences

- **Positive**: Simpler install scripts with no OS-detection branches. Consistent testing against a single base image. Aligns with enterprise Red Hat standardization.
- **Positive**: Features can rely on UBI-specific packages and repository configurations.
- **Negative**: Features are not portable to Alpine, Debian, or Ubuntu-based DevContainers.
- **Negative**: Users on non-UBI images must use other feature sets or adapt these features.

## Alternatives Considered

- **Multi-distro support**: Rejected due to complexity. Each feature would need OS detection, conditional package commands, and a doubled test matrix.
- **Alpine-first**: Rejected. Alpine's musl libc creates compatibility issues with many enterprise tools and .NET SDK.
