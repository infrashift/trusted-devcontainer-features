---
id: "01a1837f-dda1-73e8-81d0-17137e2c6147"
title: "Bootstrap environment"
type: "component"
tags:
  - "architecture"
  - "bootstrap"
  - "ansible"
created: "2026-10-28T12:12:37-05:00"
timestamp: "2026-10-28T12:20:26-05:00"
description: "The bootstrap feature installs pinned uv, Python and ansible-core into root-owned /opt/bootstrap, with the runner, inventory and site.yml."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:26-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/bootstrap/install.sh"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/bootstrap/devcontainer-feature.json"
    title: "bootstrap devcontainer-feature.json"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/decisions/adr-008-pinned-bootstrap-environment.md"
    title: "ADR-008"
---

# Bootstrap environment

The `bootstrap` feature installs one pinned Ansible environment in `/opt/bootstrap`. Every other feature uses it to install itself (ADR-008). Root owns the directory, and all users can read it. Thus the dev user can run the environment but cannot change it.

## What `bootstrap` installs

```
/usr/local/bin/uv, uvx          pinned uv, checksum verified
/opt/bootstrap/
├── python/                     uv-managed CPython (not under /root)
├── .bootstrap/                 venv with the pinned ansible-core
├── .provisioned                stamp: the three pins of this environment
├── inventory.yml               the variant, read once from /etc/os-release
├── site.yml                    the generic playbook that applies one role
├── run-feature.sh              the runner
└── tasks/install-packages.yml  the shared RPM task file
```

## Options

`src/bootstrap/devcontainer-feature.json` holds three options: `uv_version`, `python_version` and `ansible_core_version`. Read the current defaults in that file. Do not copy them here.

## How `install.sh` works

1. It stops when one of the three options is empty.
2. It stops with exit 0 when `.provisioned` holds the same three pins and the environment is complete. This occurs when a consumer pins two `bootstrap` digests, and the CLI runs the feature two times.
3. It downloads uv and verifies the SHA256. The script holds the checksums of the default uv version. For a different version, it reads the `.sha256` file of that uv release.
4. It runs `uv venv --clear` with `UV_PYTHON_INSTALL_DIR=/opt/bootstrap/python`, then installs `ansible-core==<version>`.
5. It detects the variant and writes `inventory.yml`. See [Variant detection](/architecture/variant-detection--01a1837fde02.md).
6. It copies `site.yml`, `run-feature.sh` and `tasks/install-packages.yml` from `src/bootstrap/assets/`.
7. It writes `.provisioned` last, then sets the owner to root and the mode to `a+rX`.
8. It runs `ansible-playbook --version` and `ansible-inventory` with a temporary `HOME`, so that root creates no `~/.ansible` in the home of the dev user.

## Analysis

* A change to `bootstrap` changes all features, because each dependent pins `bootstrap` by digest. See [Change the bootstrap feature](/operations/change-the-bootstrap-feature--01a1837fe171.md).
* The image is larger, because it holds a CPython runtime and `ansible-core`.

## Related

* [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md)
* [ADR-004: uv as the Ansible runner](/decisions/adr-004-uv-as-the-ansible-runner--01a183801200.md)
* [ADR-008: Pinned bootstrap environment](/decisions/adr-008-pinned-bootstrap-environment--01a1838012ac.md)
* [Feature install pipeline](/architecture/feature-install-pipeline--01a1837fdd88.md)
* [Feature dependency model](/architecture/feature-dependency-model--01a1837fddea.md)
* [Bootstrap fan-out check](/supply-chain/bootstrap-fan-out-check--01a1837fdfa2.md)
* [Features overview](/features/features-overview--01a1837af6b6.md) — the `bootstrap` feature.
* [Decisions overview](/decisions/decisions-overview--01a1837af6ce.md) — ADR-004 and ADR-008.
* [Architecture overview](/architecture/architecture-overview--01a1837af69f.md)
