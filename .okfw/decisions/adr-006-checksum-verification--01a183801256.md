---
id: "01a18380-1256-75b8-a69b-0975630d1494"
title: "ADR-006: Checksum verification"
type: "decision"
tags:
  - "decision"
  - "adr-006"
  - "checksum"
  - "supply-chain"
created: "2026-10-28T12:12:51-05:00"
timestamp: "2026-10-28T12:17:22-05:00"
description: "Accepted and amended by ADR-012: every download is verified against a SHA256 or SHA512 checksum, and verification is mandatory."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:22-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/decisions/adr-006-checksum-verification.md"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/check-role-contract.sh"
    title: "Role contract check"
---

# ADR-006: Checksum verification

ADR-006 makes the features verify each downloaded file against a SHA256 checksum. The first text made verification optional: an empty `target_checksum` skipped it. The amendment by [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md) makes verification mandatory.

**Status:** Accepted, with the implementation amended by [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md).

## Decision

As amended: every `get_url` task passes a `checksum:` argument. Each role pins a checksum for each architecture for its default version. `target_checksum` replaces the pin, and the role requires it for a version that has no pin. The amendment records that the first implementation verified nothing.

## Code check on 2026-10-28

The code agrees with the amendment. `make check-contract` fails if a `get_url` has no `checksum:`. Three tasks are exempt, because they fetch a checksums file: in `grype`, `syft` and `nodejs`. These three roles take the checksum from that file and have no pin. The ADR text names `yq` as a checksums-file feature, but `yq` now uses pinned checksums. `dotnet` and `maven` use SHA512. Installs through a package manager (`dnf5`, `uv tool`, `dotnet tool`, `bun`, `npm`) use the verification of that tool.

## Signature verification since 2026-11-04

[Feature: okfw](/features/feature-okfw--01a1a8536440.md) verifies a pinned checksum and, after that, an upstream cosign signature. The signature check uses a key that is pinned in the role. `make check-contract` exempts a task with "signature bundle" in its name, because the signature check verifies that bundle.

## Features affected

* Pinned checksum: [Feature: bun](/features/feature-bun--01a183800d6f.md), [Feature: cuelang](/features/feature-cuelang--01a183800db4.md), [Feature: dotnet](/features/feature-dotnet--01a183800dda.md), [Feature: golang](/features/feature-golang--01a183800e75.md), [Feature: gradle](/features/feature-gradle--01a183800e9f.md), [Feature: jq](/features/feature-jq--01a183800ef7.md), [Feature: maven](/features/feature-maven--01a183800f7a.md), [Feature: openjdk](/features/feature-openjdk--01a18380102a.md), [Feature: pnpm](/features/feature-pnpm--01a183801056.md), [Feature: uv-ruff](/features/feature-uv-ruff--01a183801130.md), [Feature: yq](/features/feature-yq--01a18380115a.md).
* Pinned checksum and cosign signature: [Feature: okfw](/features/feature-okfw--01a1a8536440.md).
* Pinned layer digest: [Feature: envbuilder](/features/feature-envbuilder--01a183800e01.md), [Feature: kaniko](/features/feature-kaniko--01a183800f23.md).
* Checksums file of the release: [Feature: grype](/features/feature-grype--01a183800ecb.md), [Feature: syft](/features/feature-syft--01a183801108.md), [Feature: nodejs](/features/feature-nodejs--01a183800fa6.md).
* Own checksum in `install.sh`: [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md).

## Related

* [The roles do not verify upstream signatures of downloads](/issues/the-roles-do-not-verify-upstream-signatures-of-downloads--01a18382679b.md)
* [Several ADRs state facts that the code no longer has](/issues/several-adrs-state-facts-that-the-code-no-longer-has--01a183894bf8.md)
* [Role contract](/architecture/role-contract--01a1837fddd1.md)
* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md) — the amendment.
* [Supply-chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
* [Decisions overview](/decisions/decisions-overview--01a1837af6ce.md)
