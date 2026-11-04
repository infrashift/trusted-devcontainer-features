# supply-chain

<!-- okfw:generated — maintained by okfw; edits here are overwritten -->

## Concepts

* [Bootstrap fan-out check](bootstrap-fan-out-check--01a1837fdfa2.md) - check-bootstrap-fanout.sh fails when the bootstrap version changes but a dependent feature keeps its old version.
* [CODEOWNERS](codeowners--01a1837fe0ed.md) - .github/CODEOWNERS assigns @ryancraig as the reviewer of every path but gates no merge, because the organization has one member.
* [Deploy Documentation workflow](deploy-documentation-workflow--01a1837fdf0a.md) - deploy-docs.yaml builds the Astro Starlight site in docs/ with Bun and deploys it to GitHub Pages on a push to main.
* [Feature reference rewrite](feature-reference-rewrite--01a1837fe005.md) - rewrite-feature-refs.sh changes relative ./ references to ghcr.io references at publish time; --check validates them on each pull request.
* [PR Gate workflow](pr-gate-workflow--01a1837fdeb7.md) - pr-gate.yml runs on every pull request to main, with no path filter, and publishes the required repo-gate check.
* [Pinned CI tools](pinned-ci-tools--01a1837fe09c.md) - tools.lock pins cosign, syft, grype, opa, gitleaks and the devcontainer CLI; install-tools.sh verifies opa and gitleaks checksums.
* [Policy decision point (PDP)](policy-decision-point-pdp--01a1837fdf26.md) - The OPA policy .github/pdp/policies.rego has one entry point, repo_decision, for secret scanning and tool and action pinning.
* [Published drift check](published-drift-check--01a1837fdf81.md) - check-published-drift.sh compares each feature source with the bytes published at its version; --seed copies unchanged bytes into staging.
* [Release workflow](release-workflow--01a1837fdeee.md) - release.yaml runs on each push to main: role contract, then stage, review and promote for bootstrap, then for the dependents.
* [Secret scanning](secret-scanning--01a1837fe074.md) - gitleaks scans the full history with .gitleaks.toml; three guards make sure that an empty config cannot pass as a clean scan.
* [Signing actors and keys](signing-actors-and-keys--01a1837fdf43.md) - Three GitHub environments, Build-Actor, Review-Actor and Release-Actor, separate staging, the signed verdict and the signed promotion.
* [Single policy check](single-policy-check--01a1837fe04c.md) - check-no-orphan-rego.sh fails when a .rego file exists outside .github/pdp or the policy declares a package other than tdf.pdp.
* [Stage, review and promote by digest](stage-review-and-promote-by-digest--01a1837fdf62.md) - The release publishes to a staging namespace, signs a verdict that lists digests, then copies only those digests to production.
* [Static checks](static-checks--01a1837fe0c4.md) - The table of every static check: its script, its make target, and where CI runs it.
* [Supply chain overview](supply-chain-overview--01a1837af6e6.md) - How the pipeline tests, gates, signs, stages, reviews and promotes the features, and how the PDP decides.
* [Test Features in Templates workflow](test-features-in-templates-workflow--01a1837fded2.md) - test-templates.yaml builds the affected test templates on amd64 and arm64 and reports one aggregate test/gate check.
* [Version currency check](version-currency-check--01a1837fdfe4.md) - check-version-currency.sh reports how far each pinned tool is behind upstream, and it warns without blocking.
* [Version pins check](version-pins-check--01a1837fdfc3.md) - check-version-pins.sh fails when contract-test ROLE_ARGS or test-template options pin a version that is not a declared default.
* [Workflow lint](workflow-lint--01a1837fe026.md) - lint-workflows.sh checks action SHA pins, version comments, permissions, status context names, the PR gate path filter and untrusted interpolation.

