---
id: "01a18382-6762-7e59-87b1-978359cf6bf4"
title: "The release publishes no SBOM or provenance for a feature"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "open"
  - "supply-chain"
  - "roadmap"
created: "2026-10-28T12:15:23-05:00"
timestamp: "2026-10-28T12:20:48-05:00"
description: "The release signs each feature with cosign, but publishes no SBOM and no SLSA provenance for it, as the roadmap plans."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:48-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/sign-features.sh"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/reference/roadmap.md"
    title: "docs/src/content/docs/reference/roadmap.md"
---

# The release publishes no SBOM or provenance for a feature

The release signs each feature with cosign, but it publishes no SBOM and no SLSA provenance for a feature. The roadmap plans both.

## Problem

A consumer can verify who published a feature, but cannot read what the feature installs or how the release built it. The roadmap items "SBOM Generation for Features" and "Supply Chain Attestations" are not done.

## Context

* `scripts/sign-features.sh` signs each feature digest with the release key and again keyless, with a Rekor entry.
* `.github/workflows/release.yaml` and `scripts/` have no step that makes an SBOM or a provenance attestation.
* `promote-features.sh` already copies `sha256-*.att` and `sha256-*.sbom` tags if they exist.
* A feature is metadata plus an Ansible role. The tools that it installs come at build time, so a feature SBOM can list only the pinned downloads.

## Acceptance criteria

- [ ] The release attaches a provenance attestation to each staged feature digest.
- [ ] The release attaches an SBOM, or a decision records why a feature SBOM is not useful.

## Related

* [Roadmap](/plans/roadmap--01a1838268b5.md)
* [The roles do not verify upstream signatures of downloads](/issues/the-roles-do-not-verify-upstream-signatures-of-downloads--01a18382679b.md)
* [The pipeline published unsigned features with movable action tags](/issues/the-pipeline-published-unsigned-features-with-movable-action-tags--01a183826378.md)
* [Supply-chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
