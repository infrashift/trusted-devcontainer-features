---
id: "01a1837a-f69f-77a2-b303-c60f2ef26f83"
title: "Architecture overview"
type: "overview"
tags:
  - "hub"
  - "architecture"
created: "2026-10-28T12:07:16-05:00"
timestamp: "2026-10-28T12:07:16-05:00"
description: "How a feature installs: install.sh, the bootstrap runner, and one Ansible role, with the contract that binds them."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:07:16-05:00"
status: "draft"
---

# Architecture overview

This bundle holds one concept for each part of the install system. Examples are the install pipeline, the bootstrap environment, the role contract and the test templates. Each concept says how the part works and where its source is.

Do not put step-by-step procedures here. Put them in `operations/`. Do not put the pipeline, the PDP or the static checks here. Put them in `supply-chain/`.

## Find concepts

* List this bundle: read `.okfw/architecture/index.md`.
* Search this bundle: `okfw search "<words>" --type component`.

## Add a concept

1. Search the wiki first. Update a concept that exists, if possible.
2. Run `okfw create "<Title>" --path architecture --type component -d "<one sentence>" --tags architecture`.
3. Add a link to the new concept in the list below.
4. Obey the [wiki conventions](/guides/wiki-conventions--01a1837af79c.md) and [Simplified Technical English](/guides/simplified-technical-english--01a1837af766.md).

## Concepts

### How a feature installs

* [Feature install pipeline](/architecture/feature-install-pipeline--01a1837fdd88.md) — `install.sh`, the runner, `site.yml` and the role.
* [Bootstrap environment](/architecture/bootstrap-environment--01a1837fdda1.md) — pinned uv, Python and `ansible-core` in `/opt/bootstrap`.
* [Userland and privileged lanes](/architecture/userland-and-privileged-lanes--01a1837fddb9.md) — `setpriv` to the dev user, or root with `--privileged`.
* [Role contract](/architecture/role-contract--01a1837fddd1.md) — the ADR-012 rules and `make check-contract`.
* [Feature dependency model](/architecture/feature-dependency-model--01a1837fddea.md) — `dependsOn` by digest, `installsAfter`, two-phase publish.
* [Variant detection](/architecture/variant-detection--01a1837fde02.md) — Fedora or UBI, read once from `/etc/os-release`.
* [System packages](/architecture/system-packages--01a1837fde4e.md) — the shared `dnf5` task file and the base image libraries.

### Where it installs and for whom

* [Install paths](/architecture/install-paths--01a1837fde1b.md) — `~/.local/bin` and `~/.local/share/<tool>`.
* [Dev user](/architecture/dev-user--01a1837fde35.md) — `_REMOTE_USER`, the default `dev` account, the `user` GID 0 account.

### Tests and layout

* [Test templates](/architecture/test-templates--01a1837fde68.md) — the seven dev containers and their smoke tests.
* [Contract tests](/architecture/contract-tests--01a1837fde81.md) — idempotency and failure modes.
* [Repository layout](/architecture/repository-layout--01a1837fde9c.md) — the top-level directories and the feature directory.

## Related

* [Wiki map](/wiki-map--01a1837af671.md)
* [Supply chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
* [Operations overview](/operations/operations-overview--01a1837af719.md)
* [Decisions overview](/decisions/decisions-overview--01a1837af6ce.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
