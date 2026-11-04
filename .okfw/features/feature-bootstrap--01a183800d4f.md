---
id: "01a18380-0d4f-7456-95f8-676ffe75876f"
title: "Feature: bootstrap"
type: "feature"
tags:
  - "feature"
  - "bootstrap"
  - "runner"
  - "ansible"
created: "2026-10-28T12:12:49-05:00"
timestamp: "2026-10-28T12:17:20-05:00"
description: "The bootstrap feature installs pinned uv, Python and ansible-core in /opt/bootstrap and the runner that every other feature uses."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:20-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/bootstrap/devcontainer-feature.json"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/bootstrap/install.sh"
    title: "bootstrap install.sh"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/bootstrap/assets/run-feature.sh"
    title: "The runner run-feature.sh"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/rewrite-feature-refs.sh"
    title: "Publish-time reference rewrite"
---

# Feature: bootstrap

The `bootstrap` feature makes the Ansible environment that every other feature uses to install itself. Its `install.sh` is plain bash, because it cannot use Ansible before it installs Ansible. It installs a pinned `uv` in `/usr/local/bin`, a uv-managed CPython in `/opt/bootstrap/python`, and a venv with a pinned `ansible-core` in `/opt/bootstrap/.bootstrap`. It also installs the runner `/opt/bootstrap/run-feature.sh`, the generic playbook `site.yml`, the shared task file `tasks/install-packages.yml` and a generated `inventory.yml`.

## Options

Feature version 1.6.1. The defaults are from `src/bootstrap/devcontainer-feature.json` on 2026-10-28.

| Option | Default | Use |
|---|---|---|
| `uv_version` | `0.12.24` | The uv release for `/usr/local/bin/uv`. |
| `python_version` | `3.14` | The CPython of the `.bootstrap` venv. |
| `ansible_core_version` | `2.21.3` | The `ansible-core` in the venv. |

`install.sh` stops with an error if an option is empty. It has no fallback values.

## How it installs

* `install.sh` downloads the uv tarball from the GitHub release and verifies its SHA256 checksum. The checksum for the default version is pinned in `install.sh`. For another version, it uses the `.sha256` file of that release.
* It makes the venv with `uv venv --clear` and installs `ansible-core==<version>` with `uv pip install`. `UV_PYTHON_INSTALL_DIR` is `/opt/bootstrap/python`, so the dev user can read the interpreter.
* It reads `/etc/os-release` and writes the variant, for example `fedora43` or `ubi9`, into `inventory.yml` ([ADR-010: Fedora 43 target](/decisions/adr-010-fedora-43-target--01a183801309.md)).
* It makes `/opt/bootstrap` root-owned and world-readable. The dev user can run the toolchain but cannot change it.
* It writes the stamp file `/opt/bootstrap/.provisioned` with the three pins last. A second run with the same pins does nothing. A run with different pins makes the venv again.

## The runner

`run-feature.sh --role <dir> [--privileged] [-e key=value]...` applies one role through `site.yml`. It adds `_target_username`, `_target_user_home` and `_target_arch` from `_REMOTE_USER`, `_REMOTE_USER_HOME` and `uname -m` ([ADR-011: dev user alignment](/decisions/adr-011-dev-user-alignment--01a183801339.md)). It stops with an error if the venv is missing, or if `_REMOTE_USER` or `_REMOTE_USER_HOME` is not set. In the userland lane, it uses `setpriv` to change to the dev user before Ansible starts. In the privileged lane (`--privileged`), it stays root ([ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md)).

`tasks/install-packages.yml` installs RPMs with `dnf5` for the privileged lane. The Ansible `dnf` modules cannot run from the venv, because the `libdnf5` bindings exist only for a system Python.

## Dependencies

`bootstrap` has no `dependsOn` and no `installsAfter`. Each of the other 26 features has `./bootstrap` in `dependsOn` ([ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md)). At publish time, `scripts/rewrite-feature-refs.sh` changes that reference to the production `bootstrap`, pinned by digest. Thus a change to `bootstrap` must also change the version of each dependent. `make check-fanout` enforces this fan-out rule.

## Test templates

All seven test templates in `test-templates/` list `./bootstrap` explicitly.

## Notes

* The docs site has no page for `bootstrap`. `docs/src/data/features.json` has no entry for it.
* [ADR-008: Pinned bootstrap environment](/decisions/adr-008-pinned-bootstrap-environment--01a1838012ac.md) gives the defaults Python 3.12 and `ansible-core` 2.18.2. The defaults in the code are now 3.14 and 2.21.3.

## Related

* [Published features had relative dependsOn references](/issues/published-features-had-relative-dependson-references--01a18382602b.md)
* [Feature dependsOn resolved bootstrap by tag, not by digest](/issues/feature-dependson-resolved-bootstrap-by-tag-not-by-digest--01a183826056.md)
* [The bootstrap ansible-core proposal is older than the default](/issues/the-bootstrap-ansible-core-proposal-is-older-than-the-default--01a183894d02.md)
* [Bootstrap environment](/architecture/bootstrap-environment--01a1837fdda1.md)
* [Feature install pipeline](/architecture/feature-install-pipeline--01a1837fdd88.md)
* [Bootstrap fan-out check](/supply-chain/bootstrap-fan-out-check--01a1837fdfa2.md)
* [Change the bootstrap feature](/operations/change-the-bootstrap-feature--01a1837fe171.md)
* [ADR-008: Pinned bootstrap environment](/decisions/adr-008-pinned-bootstrap-environment--01a1838012ac.md) — the pinned environment.
* [ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md) — why every feature depends on `bootstrap`.
* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md) — the runner interface and the two lanes.
* [ADR-010: Fedora 43 target](/decisions/adr-010-fedora-43-target--01a183801309.md) — the variant detection.
* [Feature: uv-ruff](/features/feature-uv-ruff--01a183801130.md) — a separate uv for the dev user.
* [Feature: ansible-core](/features/feature-ansible-core--01a183800d2e.md) — a separate `ansible-core` for the dev user.
* [Architecture overview](/architecture/architecture-overview--01a1837af69f.md)
* [Supply-chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md) — the fan-out rule and the digest pin.
* [Features overview](/features/features-overview--01a1837af6b6.md)
