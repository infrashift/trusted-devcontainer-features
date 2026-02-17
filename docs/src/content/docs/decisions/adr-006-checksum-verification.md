---
title: "ADR-006: Checksum Verification"
description: Decision to support optional SHA256 checksum verification for downloaded binaries.
---

**Status:** Accepted

## Context

Features download binaries from external sources (GitHub releases, official CDNs). Supply chain attacks targeting binary downloads are a growing concern. We needed a verification mechanism that improves security without making features harder to use.

## Decision

Support optional SHA256 checksum verification. Most features accept a `target_checksum` option. When provided, the Ansible playbook verifies the downloaded file's SHA256 hash against the expected value and fails the installation if they don't match. When the checksum is empty, the download proceeds without verification.

For some tools (Grype, Syft, yq), the Ansible playbook downloads the official checksums file from the release and verifies against that when no explicit checksum is provided.

## Consequences

- **Positive**: Users who need supply chain security can pin exact binary checksums.
- **Positive**: Verification is built into the Ansible playbook — no separate tooling needed.
- **Positive**: Optional by default — users who don't need checksums aren't burdened with managing them.
- **Negative**: Checksums must be updated manually when bumping versions. This creates maintenance overhead.
- **Negative**: Not all features support checksums (e.g., git compiles from source, npm/pip installs use their own verification).

## Alternatives Considered

- **Mandatory checksums**: Rejected. Too burdensome for users who just want the latest version.
- **GPG signature verification**: Considered for future implementation. More robust but requires managing public keys and not all upstream projects sign releases.
- **cosign/sigstore verification**: Considered for future implementation. Requires additional tooling in the base image.
