---
id: "01a18380-12db-77f0-8e3c-0f19028de875"
title: "ADR-009: Mandatory dependencies with dependsOn"
type: "decision"
tags:
  - "decision"
  - "adr-009"
  - "bootstrap"
  - "dependencies"
created: "2026-10-28T12:12:51-05:00"
timestamp: "2026-10-28T12:17:22-05:00"
description: "Accepted: every feature declares bootstrap in dependsOn, so the runtime installs it; installsAfter stays for order only. Supersedes ADR-007."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:22-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/decisions/adr-009-mandatory-dependencies.md"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/rewrite-feature-refs.sh"
    title: "Publish-time reference rewrite"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/.github/workflows/release.yaml"
    title: "Release workflow"
---

# ADR-009: Mandatory dependencies with dependsOn

ADR-009 makes each feature declare `bootstrap` in `dependsOn`. Unlike `installsAfter`, `dependsOn` makes the runtime install the other feature. `installsAfter` stays, for the order of features that do not require each other.

**Status:** Accepted. Supersedes [ADR-007: installsAfter dependency model](/decisions/adr-007-installsafter-dependency-model--01a183801281.md).

## Decision

Each feature has `"dependsOn": {"./bootstrap": {}}`, with a relative reference. The ADR rejects an absolute OCI reference, because it cannot resolve before the feature is published. The runner also stops with a clear error if `/opt/bootstrap` is missing.

## Code check on 2026-10-28

The source agrees: all 26 features other than `bootstrap` have `./bootstrap` in `dependsOn`. The published features do not agree with the ADR text. The ADR says that the relative reference works "once published". At publish time, `scripts/rewrite-feature-refs.sh` changes each `./<name>` to `ghcr.io/<repo>/<name>`, and `dependsOn` gets the production `bootstrap` pinned by digest. The reason in that script: a consumer resolves a relative reference against its own folder, and the first release failed for this reason.

## Features affected

All features. See [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md).

## Related

* [Several ADRs state facts that the code no longer has](/issues/several-adrs-state-facts-that-the-code-no-longer-has--01a183894bf8.md)
* [Published features had relative dependsOn references](/issues/published-features-had-relative-dependson-references--01a18382602b.md)
* [Feature dependency model](/architecture/feature-dependency-model--01a1837fddea.md)
* [Feature reference rewrite](/supply-chain/feature-reference-rewrite--01a1837fe005.md)
* [ADR-007: installsAfter dependency model](/decisions/adr-007-installsafter-dependency-model--01a183801281.md) — the superseded model.
* [ADR-008: Pinned bootstrap environment](/decisions/adr-008-pinned-bootstrap-environment--01a1838012ac.md) — why every feature needs `bootstrap`.
* [Supply-chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md) — the publish-time rewrite and the fan-out rule.
* [Decisions overview](/decisions/decisions-overview--01a1837af6ce.md)
