---
id: "01a1837a-f6e6-7cca-be83-f3c34aceee12"
title: "Supply chain overview"
type: "overview"
tags:
  - "hub"
  - "supply-chain"
created: "2026-10-28T12:07:16-05:00"
timestamp: "2026-10-28T12:07:16-05:00"
description: "How the pipeline tests, gates, signs, stages, reviews and promotes the features, and how the PDP decides."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:07:16-05:00"
status: "draft"
---

# Supply chain overview

This bundle holds one concept for each workflow and for each static check. It also holds concepts for the PDP, the signing actors and keys, and the staged release. It says how the pipeline tests, gates, signs, stages, reviews and promotes the features.

Do not put dated measurements here. Put them in `findings/`. Do not put step-by-step procedures here. Put them in `operations/`.

## Find concepts

* List this bundle: read `.okfw/supply-chain/index.md`.
* Search the workflows: `okfw search "<words>" --type workflow`.
* Search the other concepts: `okfw search "<words>" --type component`.

## Add a concept

1. Search the wiki first. Update a concept that exists, if possible.
2. Run `okfw create "<Title>" --path supply-chain --type workflow -d "<one sentence>" --tags supply-chain,workflow` for a workflow. Use `--type component` for all other concepts.
3. Add a link to the new concept in the list below, and a row in [Static checks](/supply-chain/static-checks--01a1837fe0c4.md) for a new check.
4. Obey the [wiki conventions](/guides/wiki-conventions--01a1837af79c.md) and [Simplified Technical English](/guides/simplified-technical-english--01a1837af766.md).

## Concepts

### Workflows

| Workflow | File | Trigger | Required status |
|---|---|---|---|
| [PR Gate workflow](/supply-chain/pr-gate-workflow--01a1837fdeb7.md) | `pr-gate.yml` | every pull request | `repo-gate` |
| [Test Features in Templates workflow](/supply-chain/test-features-in-templates-workflow--01a1837fded2.md) | `test-templates.yaml` | pull request and push, path filter | none (`test/gate` reports) |
| [Release workflow](/supply-chain/release-workflow--01a1837fdeee.md) | `release.yaml` | push to `main` | none |
| [Deploy Documentation workflow](/supply-chain/deploy-documentation-workflow--01a1837fdf0a.md) | `deploy-docs.yaml` | push to `main` in `docs/` | none |

### Release, signing and policy

* [Stage, review and promote by digest](/supply-chain/stage-review-and-promote-by-digest--01a1837fdf62.md) — the staged release and the signed verdict.
* [Signing actors and keys](/supply-chain/signing-actors-and-keys--01a1837fdf43.md) — `Build-Actor`, `Review-Actor`, `Release-Actor`, `release.pub`, `review.pub`.
* [Policy decision point (PDP)](/supply-chain/policy-decision-point-pdp--01a1837fdf26.md) — `repo_decision` and its inputs.
* [Feature reference rewrite](/supply-chain/feature-reference-rewrite--01a1837fe005.md) — `./<id>` to `ghcr.io` at publish time.
* [CODEOWNERS](/supply-chain/codeowners--01a1837fe0ed.md) — assigns, does not gate.

### Static checks

* [Static checks](/supply-chain/static-checks--01a1837fe0c4.md) — the table of all checks.
* [Published drift check](/supply-chain/published-drift-check--01a1837fdf81.md) — source compared with the published bytes; `--seed`.
* [Bootstrap fan-out check](/supply-chain/bootstrap-fan-out-check--01a1837fdfa2.md) — a `bootstrap` bump needs a bump of each dependent.
* [Version pins check](/supply-chain/version-pins-check--01a1837fdfc3.md) — `ROLE_ARGS` and template options agree with the defaults.
* [Version currency check](/supply-chain/version-currency-check--01a1837fdfe4.md) — how far each tool is behind upstream.
* [Workflow lint](/supply-chain/workflow-lint--01a1837fe026.md) — action pins, permissions, path filter, interpolation.
* [Single policy check](/supply-chain/single-policy-check--01a1837fe04c.md) — one `.rego` policy only.
* [Secret scanning](/supply-chain/secret-scanning--01a1837fe074.md) — `gitleaks` and its three guards.
* [Pinned CI tools](/supply-chain/pinned-ci-tools--01a1837fe09c.md) — `tools.lock` and `install-tools.sh`.

## Related

* [Wiki map](/wiki-map--01a1837af671.md)
* [Architecture overview](/architecture/architecture-overview--01a1837af69f.md)
* [Operations overview](/operations/operations-overview--01a1837af719.md)
* [Findings overview](/findings/findings-overview--01a1837af700.md)
* [Decisions overview](/decisions/decisions-overview--01a1837af6ce.md)
