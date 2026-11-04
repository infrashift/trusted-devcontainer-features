---
id: "01a1837a-f74b-7cc4-af12-230fd4f621d5"
title: "Plans overview"
type: "overview"
tags:
  - "hub"
  - "plan"
created: "2026-10-28T12:07:16-05:00"
timestamp: "2026-10-28T12:07:16-05:00"
description: "Plans for multi-step work, with their state and the issues that they close."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:07:16-05:00"
status: "draft"
---

# Plans overview

This bundle holds one plan concept for each piece of multi-step work, with the tag `proposed`, `active`, `done` or `dropped`.

Do not put one problem or one task here. Put it in `issues/`.

## Find concepts

* List this bundle: read `.okfw/plans/index.md`.
* Active plans: `okfw search --type plan --tag active`.
* Proposed plans: `okfw search --type plan --tag proposed`.

## Add a concept

1. Search the wiki for a plan or an issue about the same work.
2. Run `okfw create "<Title>" --path plans --type plan -d "<one sentence>" --tags plan,proposed`.
3. Write the body with the sections in [Plan workflow](/guides/plan-workflow--01a1837af7d6.md).
4. Link the plan to each issue that it closes, and link each issue back.
5. Add a link to the new plan in the list below.

## Concepts

### Active

* [Adopt OKF Wiki for project knowledge](/plans/adopt-okf-wiki-for-project-knowledge--01a1837af7f3.md) — the wiki in `.okfw/`

### Proposed

* [Roadmap](/plans/roadmap--01a1838268b5.md) — pointer to `roadmap.md`, with the state of each item on 2026-10-28
* [Bring the docs site in line with the code](/plans/bring-the-docs-site-in-line-with-the-code--01a1838268e3.md) — closes six docs issues

## Related

* [Wiki map](/wiki-map--01a1837af671.md)
* [Plan workflow](/guides/plan-workflow--01a1837af7d6.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
