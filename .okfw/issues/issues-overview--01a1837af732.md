---
id: "01a1837a-f732-7420-a415-4acec9fb5d93"
title: "Issues overview"
type: "overview"
tags:
  - "hub"
  - "issue"
created: "2026-10-28T12:07:16-05:00"
timestamp: "2026-10-28T12:07:16-05:00"
description: "All problems and tasks for this project, open and resolved."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:07:16-05:00"
status: "draft"
---

# Issues overview

This bundle holds one issue concept for each problem or task, with the tag `open` or `resolved`. The resolved issues record the notable defects that PRs and commits fixed. Routine version bumps are not here.

Do not put multi-step work here. Put it in `plans/` and link the issues.

## Find concepts

* List this bundle: read `.okfw/issues/index.md`.
* Open issues: `okfw search --kind issue --tag open`.
* Issues for one feature: `okfw search --kind issue --tag <feature>`.

## Add a concept

1. Search the wiki first. Update an issue that exists, if possible.
2. Run `okfw create "<Title>" --path issues --type issue --kind issue -d "<one sentence>" --tags issue,open`.
3. Write the body with the sections in [Issue workflow](/guides/issue-workflow--01a1837af7b9.md).
4. Add a link to the new issue in the list below.
5. Obey the [wiki conventions](/guides/wiki-conventions--01a1837af79c.md) and [Simplified Technical English](/guides/simplified-technical-english--01a1837af766.md).

## Concepts

### Open

* [Old production version tags still point at newer builds](/issues/old-production-version-tags-still-point-at-newer-builds--01a1838264a1.md) — release
* [The main ruleset does not require test/gate](/issues/the-main-ruleset-does-not-require-test-gate--01a1838264d9.md) — GitHub settings
* [CODEOWNERS and the human gate assume a multi-person org](/issues/codeowners-and-the-human-gate-assume-a-multi-person-org--01a183826510.md) — GitHub settings
* [The docs site says the features target UBI 9](/issues/the-docs-site-says-the-features-target-ubi-9--01a18382654c.md) — docs
* [The architecture page disagrees with the code](/issues/the-architecture-page-disagrees-with-the-code--01a183826585.md) — docs
* [The docs site does not describe the release pipeline or signature checks](/issues/the-docs-site-does-not-describe-the-release-pipeline-or-signature-checks--01a1838265c1.md) — docs
* [The getting-started Node.js example fails with the default npm](/issues/the-getting-started-node-js-example-fails-with-the-default-npm--01a1838265fc.md) — docs, `nodejs`
* [The README and the npm page do not say that npm is deprecated](/issues/the-readme-and-the-npm-page-do-not-say-that-npm-is-deprecated--01a183826637.md) — docs, `npm`
* [Role compatibility lists name UBI variants that CI does not test](/issues/role-compatibility-lists-name-ubi-variants-that-ci-does-not-test--01a183826669.md) — testing
* [The currency check skips the bootstrap, ruff and sqlpackage pins](/issues/the-currency-check-skips-the-bootstrap-ruff-and-sqlpackage-pins--01a183826696.md) — version currency
* [The kaniko role cannot install kaniko 1.29 or later](/issues/the-kaniko-role-cannot-install-kaniko-1-29-or-later--01a1838266c2.md) — `kaniko`
* [The pnpm role cannot install pnpm 11 or later](/issues/the-pnpm-role-cannot-install-pnpm-11-or-later--01a1838266f1.md) — `pnpm`
* [Four containerEnv values name /home/dev](/issues/four-containerenv-values-name-home-dev--01a183826729.md) — dev user
* [The release publishes no SBOM or provenance for a feature](/issues/the-release-publishes-no-sbom-or-provenance-for-a-feature--01a183826762.md) — roadmap
* [The roles do not verify upstream signatures of downloads](/issues/the-roles-do-not-verify-upstream-signatures-of-downloads--01a18382679b.md) — roadmap
* [The roadmap page lists done work as planned](/issues/the-roadmap-page-lists-done-work-as-planned--01a1838267d2.md) — docs
* [Several ADRs state facts that the code no longer has](/issues/several-adrs-state-facts-that-the-code-no-longer-has--01a183894bf8.md) — docs, ADRs
* [Feature docs pages disagree with the code](/issues/feature-docs-pages-disagree-with-the-code--01a183894c2e.md) — docs
* [Binaries from go install are not on PATH](/issues/binaries-from-go-install-are-not-on-path--01a183894c64.md) — `golang`
* [Code comments give old counts and names](/issues/code-comments-give-old-counts-and-names--01a183894c99.md) — comments
* [Unused script and unused policy rules](/issues/unused-script-and-unused-policy-rules--01a183894cce.md) — supply chain
* [The bootstrap ansible-core proposal is older than the default](/issues/the-bootstrap-ansible-core-proposal-is-older-than-the-default--01a183894d02.md) — `bootstrap`
* [The maintainer dev container pins old versions and the deprecated npm feature](/issues/the-maintainer-dev-container-pins-old-versions-and-the-deprecated-npm-feature--01a183894d35.md) — maintainer dev container
* [The npm feature is deprecated only in prose](/issues/the-npm-feature-is-deprecated-only-in-prose--01a183894d6a.md) — `npm`

### Resolved: release and supply chain

* [The pipeline published unsigned features with movable action tags](/issues/the-pipeline-published-unsigned-features-with-movable-action-tags--01a183826378.md) (PR #1)
* [Published features had relative dependsOn references](/issues/published-features-had-relative-dependson-references--01a18382602b.md) (PR #2)
* [Feature dependsOn resolved bootstrap by tag, not by digest](/issues/feature-dependson-resolved-bootstrap-by-tag-not-by-digest--01a183826056.md) (PRs #8, #9)
* [The main branch had no protection](/issues/the-main-branch-had-no-protection--01a183826317.md) (PR #11)
* [Network calls had no retries, and two installers were piped into sh](/issues/network-calls-had-no-retries-and-two-installers-were-piped-into-sh--01a183826344.md) (PR #12)
* [The release published to production before a review](/issues/the-release-published-to-production-before-a-review--01a18382607e.md) (PR #13)
* [An unchanged feature got a new digest on each staged release](/issues/an-unchanged-feature-got-a-new-digest-on-each-staged-release--01a1838260a7.md) (PR #15)
* [Promotion copied features to production before it signed them](/issues/promotion-copied-features-to-production-before-it-signed-them--01a1838260f4.md) (PR #20)
* [Promotion moved old version tags onto the newest build](/issues/promotion-moved-old-version-tags-onto-the-newest-build--01a1838260cd.md) (PR #23)

### Resolved: CVEs and version currency

* [Feature tool pins were far behind upstream](/issues/feature-tool-pins-were-far-behind-upstream--01a183826297.md) (PRs #3, #4)
* [Test copies of the version defaults drifted from the declared defaults](/issues/test-copies-of-the-version-defaults-drifted-from-the-declared-defaults--01a1838262c3.md) (PRs #3, #5)
* [No check reported how far pinned tools were behind upstream](/issues/no-check-reported-how-far-pinned-tools-were-behind-upstream--01a1838262eb.md) (PR #5)
* [The npm feature shipped a tar with a Critical advisory](/issues/the-npm-feature-shipped-a-tar-with-a-critical-advisory--01a1838261fd.md) (PR #6)
* [CPython 3.13 had CVE-2026-82049 with no fix on its line](/issues/cpython-3-13-had-cve-2026-82049-with-no-fix-on-its-line--01a183826199.md) (PR #21)
* [uv 0.12.5 installed CPython 3.14.7, which has two CVEs](/issues/uv-0-12-5-installed-cpython-3-14-7-which-has-two-cves--01a1838261cb.md) (PR #24)
* [The nodejs feature shipped a bundled npm with known advisories](/issues/the-nodejs-feature-shipped-a-bundled-npm-with-known-advisories--01a183826230.md) (PR #30)

### Resolved: features and tests

* [The maintainer dev container could not be built](/issues/the-maintainer-dev-container-could-not-be-built--01a1838263ac.md) (PR #1)
* [The make test targets called a test tree that did not exist](/issues/the-make-test-targets-called-a-test-tree-that-did-not-exist--01a1838263e4.md) (PR #1)
* [claude-code and openai-codex did not upgrade from latest](/issues/claude-code-and-openai-codex-did-not-upgrade-from-latest--01a18382642c.md) (PR #1)
* [The openjdk role rejected Adoptium four-part versions](/issues/the-openjdk-role-rejected-adoptium-four-part-versions--01a18382646a.md) (PR #4)
* [Workspace images had no make](/issues/workspace-images-had-no-make--01a183826263.md) (PR #17)
* [The sqlpackage feature could not find the .NET runtime](/issues/the-sqlpackage-feature-could-not-find-the-net-runtime--01a183826142.md) (PRs #18, #19)
* [The test templates used an account that no seed uses](/issues/the-test-templates-used-an-account-that-no-seed-uses--01a18382611a.md) (PR #20)
* [The python feature skipped the interpreter install after uv-ruff](/issues/the-python-feature-skipped-the-interpreter-install-after-uv-ruff--01a18382616d.md) (PR #22)

## Related

* [Wiki map](/wiki-map--01a1837af671.md)
* [Issue workflow](/guides/issue-workflow--01a1837af7b9.md)
* [Plans overview](/plans/plans-overview--01a1837af74b.md)
* [Findings overview](/findings/findings-overview--01a1837af700.md)
* [Supply-chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
