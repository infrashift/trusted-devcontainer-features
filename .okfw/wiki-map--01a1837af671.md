---
id: "01a1837a-f671-70ab-900c-6eecf3710215"
title: "Wiki map"
type: "map"
tags:
  - "hub"
  - "map"
created: "2026-10-28T12:07:16-05:00"
timestamp: "2026-10-28T12:07:16-05:00"
description: "Start here: what this wiki holds, the bundles, and the commands for common questions."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:07:16-05:00"
status: "draft"
---

# Wiki map

This wiki holds the knowledge about the trusted dev container features that the code does not show: reasons, findings, issues, plans and runbooks.

The project publishes signed dev container features for Fedora 43 and Red Hat UBI. Each feature is metadata, a five-line `install.sh`, and one Ansible role that the `bootstrap` runner applies.

## Start here

1. Read this map. Choose the bundle for your question.
2. Read the overview of that bundle.
3. Open only the concepts whose description matches your question.
4. Follow `resource` and `sources` to the repository only when necessary.

## Bundles

| Bundle | Use it for |
|---|---|
| [guides/](/guides/guides-overview--01a1837af687.md) | Read first. Writing rules, words, and how to track issues and plans. |
| [architecture/](/architecture/architecture-overview--01a1837af69f.md) | How a feature installs, and the contract that binds the parts. |
| [features/](/features/features-overview--01a1837af6b6.md) | One concept for each published feature. |
| [decisions/](/decisions/decisions-overview--01a1837af6ce.md) | One pointer for each ADR. |
| [supply-chain/](/supply-chain/supply-chain-overview--01a1837af6e6.md) | Test, gate, sign, stage, review and promote, and the PDP. |
| [findings/](/findings/findings-overview--01a1837af700.md) | Dated measurements. |
| [operations/](/operations/operations-overview--01a1837af719.md) | Runbooks to add, change, test, check and release a feature. |
| [issues/](/issues/issues-overview--01a1837af732.md) | Open and resolved problems and tasks. |
| [plans/](/plans/plans-overview--01a1837af74b.md) | Multi-step work and its state. |

## Common questions

| Question | Command |
|---|---|
| What is open? | `okfw search --kind issue --tag open` |
| What work is in progress? | `okfw search --type plan --tag active` |
| What do we know about one feature? | `okfw search --tag <feature>` |
| Which facts are out of date? | `okfw search --stale` |
| What is not reviewed? | `okfw search --status draft` |
| What links to a concept? | `okfw backlinks <id>` |

## Other wikis

The templates consume these features. The templates repository has its own wiki: [trusted-devcontainer-templates wiki map](https://github.com/infrashift/trusted-devcontainer-templates/blob/main/.okfw/wiki-map--01a1833f67c2.md).
