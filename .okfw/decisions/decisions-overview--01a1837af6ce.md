---
id: "01a1837a-f6ce-77fd-bbc3-060878758387"
title: "Decisions overview"
type: "overview"
tags:
  - "hub"
  - "decision"
created: "2026-10-28T12:07:16-05:00"
timestamp: "2026-10-28T12:07:16-05:00"
description: "One pointer concept for each architecture decision record (ADR) in the documentation site."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:07:16-05:00"
status: "draft"
---

# Decisions overview

This bundle holds one pointer concept for each ADR in `docs/src/content/docs/decisions/`. The ADR file is the source of truth. Each concept gives the status, the decision, the links to the features that it affects, and a code check with a date.

Do not record a new decision here first. Write the ADR in `docs/`, then add the pointer here.

## Find concepts

* List this bundle: read `.okfw/decisions/index.md`.
* Search this bundle: `okfw search "<words>" --type decision`.
* Find one ADR: `okfw search "adr" --tag adr-0NN`.

## Add a concept

1. Write the ADR in `docs/src/content/docs/decisions/adr-0NN-<slug>.md` first.
2. Run `okfw create "ADR-0NN: <short title>" --path decisions --type decision -d "<status>: <one sentence>" --tags decision,adr-0NN`.
3. Set `resource` to the GitHub URL of the ADR file. Compare the ADR with the code and record the result under "Code check".
4. Add a link to the new concept in the list below. If it supersedes an ADR, move that ADR to "Superseded". Obey the [wiki conventions](/guides/wiki-conventions--01a1837af79c.md) and [Simplified Technical English](/guides/simplified-technical-english--01a1837af766.md).

## Concepts

### Current

| Concept | Decision |
|---|---|
| [ADR-002: Ansible as the feature installer](/decisions/adr-002-ansible-as-the-feature-installer--01a1838011ad.md) | Ansible installs each feature. |
| [ADR-005: Bun as the package manager](/decisions/adr-005-bun-as-the-package-manager--01a18380122a.md) | Bun installs the AI CLIs and manages the docs site. |
| [ADR-006: Checksum verification](/decisions/adr-006-checksum-verification--01a183801256.md) | Every download has a checksum. Amended by ADR-012. |
| [ADR-008: Pinned bootstrap environment](/decisions/adr-008-pinned-bootstrap-environment--01a1838012ac.md) | Pinned uv, CPython and `ansible-core` in `/opt/bootstrap`. |
| [ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md) | Every feature has `bootstrap` in `dependsOn`. |
| [ADR-010: Fedora 43 target](/decisions/adr-010-fedora-43-target--01a183801309.md) | Fedora 43 and UBI, with the variant detected once. |
| [ADR-011: dev user alignment](/decisions/adr-011-dev-user-alignment--01a183801339.md) | The dev user is `dev`, UID 1001, from the CLI variables. |
| [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md) | The runner, the two lanes and the parameter rules. |

### Superseded

| Concept | Decision |
|---|---|
| [ADR-001: UBI 9 base image](/decisions/adr-001-ubi-9-base-image--01a183801183.md) | UBI 9 only. Superseded by ADR-010. |
| [ADR-003: Non-root vscode user](/decisions/adr-003-non-root-vscode-user--01a1838011d7.md) | `vscode` user, UID 1000. Superseded by ADR-011. |
| [ADR-004: uv as the Ansible runner](/decisions/adr-004-uv-as-the-ansible-runner--01a183801200.md) | `uv run --with ansible-core`. Superseded by ADR-008. |
| [ADR-007: installsAfter dependency model](/decisions/adr-007-installsafter-dependency-model--01a183801281.md) | `installsAfter` only. Superseded by ADR-009. |

## Related

* [Wiki map](/wiki-map--01a1837af671.md)
* [Features overview](/features/features-overview--01a1837af6b6.md) — the features that the ADRs shape.
* [Architecture overview](/architecture/architecture-overview--01a1837af69f.md)
* [Supply-chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
* [Findings overview](/findings/findings-overview--01a1837af700.md)
