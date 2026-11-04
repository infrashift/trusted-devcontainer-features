---
id: "01a1837a-f780-7bb6-a60f-369d82d0faa1"
title: "Terminology"
type: "guide"
tags:
  - "guide"
  - "ste"
  - "terminology"
created: "2026-10-28T12:07:16-05:00"
timestamp: "2026-10-28T12:08:38-05:00"
description: "The controlled words of this project: one word for one thing, and one meaning for each word."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:08:38-05:00"
status: "draft"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-templates/blob/main/.okfw/guides/terminology--01a1833e4dc1.md"
    title: "Terminology in the templates wiki"
---

# Terminology

Use these words with these meanings only. If you need a new word, add it here first.

## Rule

* Use one word for one thing. Do not use a synonym for variety.
* Use each word with one meaning. Do not use "feature" to mean "capability".
* Write technical names (commands, paths, flags, file names) in code font.

## Product words

| Word | Meaning | Do not use |
|---|---|---|
| feature | One dev container feature in `src/<name>/`. The pipeline publishes it as an OCI artifact under `ghcr.io/infrashift/trusted-devcontainer-features/<name>`. | plugin, add-on, capability |
| option | One entry in `options` of `devcontainer-feature.json`. The user sets it in `devcontainer.json`. | parameter (for the user side), setting |
| role | The Ansible role in `src/<name>/role/` that does the installation. | playbook, script |
| `install.sh` | The five-line wrapper in each feature. It passes the options to the runner. | installer |
| bootstrap | The feature that installs pinned uv, Python and ansible-core in `/opt/bootstrap` (ADR-008). Every other feature depends on it. | base feature |
| runner | `/opt/bootstrap/run-feature.sh`. It applies one role. | executor, driver |
| role contract | The rules in ADR-012 that each role and `install.sh` obey. `make check-contract` enforces them. | interface, API |
| userland lane | The default way the runner applies a role: it drops from root to the dev user with `setpriv` (ADR-012). | user mode |
| privileged lane | The way the runner applies a role as root, when `install.sh` passes `--privileged` (ADR-012). | root mode, sudo mode |
| `dependsOn` | The field in `devcontainer-feature.json` that names a required feature, pinned by digest. | requires, depends |
| test template | One dev container in `test-templates/<name>/`. CI builds it to test the features. | fixture, sample |
| template | A dev container template in the repository `trusted-devcontainer-templates`. It consumes the features. | test template (when you mean this) |
| dev user | The non-root user that the container runs as (ADR-003, ADR-011). | vscode user |

## Supply-chain words

| Word | Meaning | Do not use |
|---|---|---|
| pin | A reference to an exact version or a `sha256` digest. Also the act of setting one. | lock, freeze |
| digest | The `sha256:` value that identifies one OCI artifact. | hash, SHA |
| checksum | The `sha256` value that verifies one downloaded file (ADR-006). | digest (for a file) |
| PDP | The policy decision point: the OPA policy in `.github/pdp/policies.rego`. | gate (alone), checker |
| repo gate | `make repo-gate`: the PDP entry point `repo_decision` against the working tree. | scan |
| stage | Publish a feature into the staging namespace. The Build-Actor does it. | pre-release |
| review | Read a staged feature back and sign a verdict. The Review-Actor does it. | approve |
| promote | Copy the reviewed digests into the production namespace and sign them. The Release-Actor does it. | release (for this step), deploy |
| verdict | The signed list of digests that passed the review. | decision, result |
| signing actor | One of the three pipeline identities: Build-Actor, Review-Actor, Release-Actor. | role, bot |
| published drift | Source that is different from the published bytes at the same version. `make check-published-drift` finds it. | drift (alone) |
| version currency | How far a pinned tool is behind upstream. `make check-currency` reports it. | freshness, staleness |
| fan-out | The rule that a change to `bootstrap` also changes the version of each dependent. `make check-fanout` enforces it. | cascade |
| advisory | One published vulnerability record, for example a GHSA or CVE. | vuln, finding (alone) |

## Wiki words

| Word | Meaning | Do not use |
|---|---|---|
| concept | One markdown file in `.okfw/`. It holds one idea. | note, page, doc |
| bundle | One directory in `.okfw/`, with its generated `index.md`. | folder, section |
| overview | The concept that explains one bundle. Tag: `hub`. | readme, landing page |
| wiki actor | The writer of a concept, in `generated.by` or `verified[].by`. | author |
| issue | A concept of kind `issue`. It records one problem or one task. | ticket, bug, TODO |
| plan | A concept of type `plan`. It records the steps of one piece of work. | proposal, spec |
| finding | A concept of type `finding`. It records one measured fact with a date. | note, observation |

## Related

* [Simplified Technical English](/guides/simplified-technical-english--01a1837af766.md)
* [Wiki conventions](/guides/wiki-conventions--01a1837af79c.md)
