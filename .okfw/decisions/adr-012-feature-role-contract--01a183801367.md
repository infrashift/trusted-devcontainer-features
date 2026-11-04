---
id: "01a18380-1367-7d7a-aaa5-4b271be20b5e"
title: "ADR-012: Feature role contract"
type: "decision"
tags:
  - "decision"
  - "adr-012"
  - "role-contract"
  - "runner"
created: "2026-10-28T12:12:51-05:00"
timestamp: "2026-10-28T12:17:22-05:00"
description: "Accepted: one shared runner, a userland and a privileged lane, empty role defaults, parameter asserts and idempotent roles, enforced by make check-contract."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:22-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/decisions/adr-012-feature-role-contract.md"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/check-role-contract.sh"
    title: "Role contract check"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/bootstrap/assets/run-feature.sh"
    title: "The runner run-feature.sh"
---

# ADR-012: Feature role contract

ADR-012 defines the rules that each role and each `install.sh` obey: the role contract. One shared runner applies every role, and `install.sh` is a wrapper of about five lines with no logic. `make check-contract` enforces the contract.

**Status:** Accepted. It amends [ADR-006: Checksum verification](/decisions/adr-006-checksum-verification--01a183801256.md) and tightens [ADR-002: Ansible as the feature installer](/decisions/adr-002-ansible-as-the-feature-installer--01a1838011ad.md).

## Decision

* `/opt/bootstrap/run-feature.sh` applies the role through one generic `site.yml`. It has a userland lane, which drops to the dev user with `setpriv`, and a privileged lane (`--privileged`), which stays root.
* `devcontainer-feature.json` holds every option default. Each `defaults/main.yml` is empty. `install.sh` guards each mandatory option with `${VAR:?}`, and each role asserts the runner variables and its parameters, including their form.
* Every `get_url` passes a `checksum:`. The final assert checks the requested version, not only the binary.
* A second run must report `changed=0`. `test-templates/shared/contract-tests.sh` tests this and the failure modes.

## Code check on 2026-10-28

The code agrees with the rules. `scripts/check-role-contract.sh` runs as `make check-contract`, in `pr-gate.yml` and as a job in `release.yaml`. No `defaults/main.yml` declares a variable. `.devcontainer/SKELETON-feature/` exists. Some facts in the ADR text are out of date:

* It says that the privileged lane is "currently `git` and `git-lfs`". The code also runs `make` and `sshd` with `--privileged`.
* It names `dotnet` as "the lone SHA512". `maven` also uses SHA512.
* It counts 21 features. The repository has 27.

## Features affected

All features. Privileged lane: [Feature: git](/features/feature-git--01a183800e27.md), [Feature: git-lfs](/features/feature-git-lfs--01a183800e4e.md), [Feature: make](/features/feature-make--01a183800f4f.md), [Feature: sshd](/features/feature-sshd--01a1838010dc.md).

## Related

* [The architecture page disagrees with the code](/issues/the-architecture-page-disagrees-with-the-code--01a183826585.md)
* [Several ADRs state facts that the code no longer has](/issues/several-adrs-state-facts-that-the-code-no-longer-has--01a183894bf8.md)
* [Role contract](/architecture/role-contract--01a1837fddd1.md)
* [Userland and privileged lanes](/architecture/userland-and-privileged-lanes--01a1837fddb9.md)
* [Contract tests](/architecture/contract-tests--01a1837fde81.md)
* [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) — supplies the runner.
* [ADR-006: Checksum verification](/decisions/adr-006-checksum-verification--01a183801256.md) — the checksum rule that this ADR amends.
* [ADR-002: Ansible as the feature installer](/decisions/adr-002-ansible-as-the-feature-installer--01a1838011ad.md) — the choice of Ansible.
* [ADR-011: dev user alignment](/decisions/adr-011-dev-user-alignment--01a183801339.md) — the user variables of the runner.
* [Supply-chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md) — `make check-contract` and the CI gates.
* [Decisions overview](/decisions/decisions-overview--01a1837af6ce.md)
