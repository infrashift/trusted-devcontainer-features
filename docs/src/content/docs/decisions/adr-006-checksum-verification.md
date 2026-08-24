---
title: "ADR-006: Checksum Verification"
description: Decision to support optional SHA256 checksum verification for downloaded binaries.
---

**Status:** Accepted — implementation amended by [ADR-012](/trusted-devcontainer-features/decisions/adr-012-feature-role-contract/)

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

## Amendment (ADR-012)

This ADR was Accepted, but the implementation did not exist. `_cue_checksum`, `_uv_checksum`, and the
`target_checksum` options were declared and defaulted to empty, and **no `get_url` task ever passed a
`checksum:` argument** — one task was literally named *"Download CUElang binary (No checksum verification)"*.
The `_cue_checksums_download_url` default pointed at a `checksums.txt` release asset that `cue-lang/cue`
does not publish, so it would have 404'd had anything used it.

Under [ADR-012](/trusted-devcontainer-features/decisions/adr-012-feature-role-contract/) verification is now structural:

- Every `get_url` passes a `checksum:` argument.
- Each role pins per-architecture SHA256 digests for the version it ships by default.
- `target_checksum` overrides the pin, and is **required** when installing a non-default version — the
  role asserts a checksum is available and fails with an actionable message rather than downloading blind.

This changes the "optional by default" posture recorded above: verification is now mandatory, and the
option exists to supply a digest rather than to skip one.
