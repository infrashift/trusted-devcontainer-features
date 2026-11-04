---
id: "01a1837a-f719-71e2-9158-1c6217294153"
title: "Operations overview"
type: "overview"
tags:
  - "hub"
  - "runbook"
created: "2026-10-28T12:07:16-05:00"
timestamp: "2026-10-28T12:07:16-05:00"
description: "Runbooks: the steps to add, change, test, check and release a feature, and to set up the environments."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:07:16-05:00"
status: "draft"
---

# Operations overview

This bundle holds one runbook for each procedure. Each runbook gives numbered steps and points to the script, `make` target or document that it uses.

Do not put the reasons for a procedure here. Put them in `architecture/`, `supply-chain/` or `decisions/`.

## Find concepts

* List this bundle: read `.okfw/operations/index.md`.
* Search this bundle: `okfw search "<words>" --type runbook`.

## Add a concept

1. Search the wiki first. Update a concept that exists, if possible.
2. Run `okfw create "<Title>" --path operations --type runbook -d "<one sentence>" --tags runbook`.
3. Write the steps as a numbered list. Start each step with a verb.
4. Add a link to the new concept in the list below.
5. Obey the [wiki conventions](/guides/wiki-conventions--01a1837af79c.md) and [Simplified Technical English](/guides/simplified-technical-english--01a1837af766.md).

## Concepts

### Change features

* [Add a new feature](/operations/add-a-new-feature--01a1837fe116.md) — from `SKELETON-feature` to a merged pull request.
* [Change a feature and bump its version](/operations/change-a-feature-and-bump-its-version--01a1837fe143.md) — each source change needs a new `version`.
* [Change the bootstrap feature](/operations/change-the-bootstrap-feature--01a1837fe171.md) — fan-out to every dependent.
* [Check version currency and update a pin](/operations/check-version-currency-and-update-a-pin--01a1837fe233.md) — `make check-currency`, then update.

### Test and check locally

* [Run the static checks and the repo gate locally](/operations/run-the-static-checks-and-the-repo-gate-locally--01a1837fe1ba.md) — `make tools`, `make check`.
* [Test one template locally](/operations/test-one-template-locally--01a1837fe195.md) — `make test-template`, `make test-contract`, `make clean`.
* [Use the maintainer dev container](/operations/use-the-maintainer-dev-container--01a1837fe25c.md) — `.devcontainer/` and `prepare-devcontainer.sh`.
* [Run the documentation site locally](/operations/run-the-documentation-site-locally--01a1837fe289.md) — `make docs-dev`.

### Release and setup

* [Release and promote the features](/operations/release-and-promote-the-features--01a1837fe1e1.md) — merge, read the reviews, approve two `Release-Actor` gates.
* [Verify a published feature](/operations/verify-a-published-feature--01a1837fe2c1.md) — `cosign verify` with `release.pub`.
* [Set up the GitHub environments and signing keys](/operations/set-up-the-github-environments-and-signing-keys--01a1837fe20a.md) — the one-time setup in `SETUP-ENVIRONMENTS.md`.

## Related

* [Wiki map](/wiki-map--01a1837af671.md)
* [Architecture overview](/architecture/architecture-overview--01a1837af69f.md)
* [Supply chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
* [Issues overview](/issues/issues-overview--01a1837af732.md)
