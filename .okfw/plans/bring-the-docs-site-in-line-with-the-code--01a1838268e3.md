---
id: "01a18382-68e3-728d-bfa4-f0390f40cf5e"
title: "Bring the docs site in line with the code"
type: "plan"
tags:
  - "plan"
  - "proposed"
  - "docs"
created: "2026-10-28T12:15:24-05:00"
timestamp: "2026-10-28T12:20:56-05:00"
description: "Correct the docs site pages that disagree with the code: the UBI claims, the architecture page, the examples, the npm status and the roadmap."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:56-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/tree/main/docs/src/content/docs"
---

# Bring the docs site in line with the code

This plan corrects the docs site pages that disagree with the code. The code is the source of truth for each fact.

## Goal

Each statement on the docs site and in `README.md` agrees with `src/`, `scripts/`, the `Makefile` and the workflows. A consumer can learn from the docs site how to verify a feature.

## Context

On 2026-10-28 a check of the docs site against the code found these issues:

* [The docs site says the features target UBI 9](/issues/the-docs-site-says-the-features-target-ubi-9--01a18382654c.md)
* [The architecture page disagrees with the code](/issues/the-architecture-page-disagrees-with-the-code--01a183826585.md)
* [The docs site does not describe the release pipeline or signature checks](/issues/the-docs-site-does-not-describe-the-release-pipeline-or-signature-checks--01a1838265c1.md)
* [The getting-started Node.js example fails with the default npm](/issues/the-getting-started-node-js-example-fails-with-the-default-npm--01a1838265fc.md)
* [The README and the npm page do not say that npm is deprecated](/issues/the-readme-and-the-npm-page-do-not-say-that-npm-is-deprecated--01a183826637.md)
* [The roadmap page lists done work as planned](/issues/the-roadmap-page-lists-done-work-as-planned--01a1838267d2.md)

Other text that is wrong but small: `getting-started.md` line 115 says "all six templates", but the `Makefile` has seven. `SETUP-ENVIRONMENTS.md` has two sections with the number 6.

## Steps

1. Correct `index.mdx`, `getting-started.md`, `architecture.md`, `roadmap.md` and `README.md`.
2. Write one docs page about the release pipeline and signature verification.
3. Change the UBI text in the feature `description` fields. Bump the version of each changed feature.
4. Run `make check`, then build the docs site with `bun run build` in `docs/`.
5. Close each issue above with a `## Resolution` section.

WARNING: A change to a feature `description` changes the published bytes. You must bump the feature version, or `make check-published-drift` fails.

## Verification

* Each issue in the Context list has the tag `resolved`.
* The docs site build passes.

## Related

* [Several ADRs state facts that the code no longer has](/issues/several-adrs-state-facts-that-the-code-no-longer-has--01a183894bf8.md)
* [Feature docs pages disagree with the code](/issues/feature-docs-pages-disagree-with-the-code--01a183894c2e.md)
* [Roadmap](/plans/roadmap--01a1838268b5.md)
* [Role compatibility lists name UBI variants that CI does not test](/issues/role-compatibility-lists-name-ubi-variants-that-ci-does-not-test--01a183826669.md)
* [Architecture overview](/architecture/architecture-overview--01a1837af69f.md)
* [Plans overview](/plans/plans-overview--01a1837af74b.md)
