---
id: "01a18382-679b-74da-81a5-207a608875ef"
title: "The roles do not verify upstream signatures of downloads"
type: "issue"
kind: "issue"
tags:
  - "issue"
  - "open"
  - "supply-chain"
  - "roadmap"
created: "2026-10-28T12:15:23-05:00"
timestamp: "2026-10-28T12:20:48-05:00"
description: "The roles verify downloads with sha256 checksums only; no role runs cosign verify on tools that publish signatures, such as syft and grype."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:48-05:00"
status: "draft"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/reference/roadmap.md"
    title: "docs/src/content/docs/reference/roadmap.md"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/decisions/adr-006-checksum-verification.md"
    title: "docs/src/content/docs/decisions/adr-006-checksum-verification.md"
---

# The roles do not verify upstream signatures of downloads

Each role verifies a download with a pinned `sha256` (or `sha512`) checksum. No role verifies an upstream cosign signature, also for tools that publish one.

## Problem

A checksum shows that the file is the file that the maintainer pinned. It does not show that the upstream project built it. The roadmap item "Cosign Signature Verification" (for example syft and grype) is not done.

## Context

* ADR-006 sets the checksum rule. `make check-contract` enforces that every download has a checksum.
* `syft` and `grype` verify against the upstream checksums file. `jq`, `yq` and others carry pinned tables in `vars/main.yml`.
* On 2026-10-28, a search of `src/` for `cosign` found no match.
* On 2026-11-04, [Feature: okfw](/features/feature-okfw--01a1a8536440.md) became the first role that verifies an upstream cosign signature. Its module `okfw_verify_blob` supports only key-signed bundles. It rejects a keyless bundle.
* `syft` and `grype` use keyless signing (a Fulcio certificate and a Rekor entry). The `okfw` module cannot verify that. A role for them needs `cosign` or a verifier that checks the certificate chain and the Rekor entry.
* The `okfw` module is in the `okfw` role, not in `bootstrap`. A module in `bootstrap` would make a version bump necessary for each feature (`make check-fanout`). Move it to `bootstrap` when a second role needs it.
* `sqlpackage` and `uv-ruff` (ruff) install through NuGet and uv, with no pinned file checksum.

## Acceptance criteria

- [ ] Each role for a tool that publishes cosign signatures verifies the signature before it installs the tool,
- [ ] or a decision records why a pinned checksum is sufficient.

## Related

* [Feature: okfw](/features/feature-okfw--01a1a8536440.md) — the first role that verifies a signature.
* [ADR-006: Checksum verification](/decisions/adr-006-checksum-verification--01a183801256.md)
* [The release publishes no SBOM or provenance for a feature](/issues/the-release-publishes-no-sbom-or-provenance-for-a-feature--01a183826762.md)
* [Roadmap](/plans/roadmap--01a1838268b5.md)
* [Decisions overview](/decisions/decisions-overview--01a1837af6ce.md)
* [Supply-chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
