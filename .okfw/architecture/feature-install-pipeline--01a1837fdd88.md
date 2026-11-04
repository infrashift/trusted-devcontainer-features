---
id: "01a1837f-dd88-796f-b780-2b727cf0f0a5"
title: "Feature install pipeline"
type: "component"
tags:
  - "architecture"
  - "install-pipeline"
  - "runner"
created: "2026-10-28T12:12:37-05:00"
timestamp: "2026-10-28T12:20:26-05:00"
description: "Each feature installs in three stages: install.sh calls /opt/bootstrap/run-feature.sh, which runs site.yml to apply the feature role."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:26-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/bootstrap/assets/run-feature.sh"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/reference/architecture.md"
    title: "Architecture reference page"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/bootstrap/assets/site.yml"
    title: "site.yml"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/jq/install.sh"
    title: "jq install.sh (example wrapper)"
---

# Feature install pipeline

Each feature installs in three stages. `install.sh` calls the runner `/opt/bootstrap/run-feature.sh`. The runner calls `ansible-playbook` with the shared `site.yml`, and `site.yml` applies the feature role. A feature holds no installation logic outside its role.

```
install.sh  ->  /opt/bootstrap/run-feature.sh  ->  /opt/bootstrap/site.yml  ->  ansible-role-feature
```

## Stage 1: `install.sh`

* The devcontainer CLI runs `install.sh` as root during the container build. The CLI also sets each option as an uppercase environment variable.
* `install.sh` stops on an empty mandatory option with `${VAR:?}`. A `*_checksum` option can be empty, so it uses `${VAR:-}`.
* `install.sh` then runs `exec /opt/bootstrap/run-feature.sh --role ansible-role-feature`, with one `-e` extra-var for each option. The extra-var has the role-internal name, for example `_jq_version`.
* A feature that changes system state also passes `--privileged`. See [Userland and privileged lanes](/architecture/userland-and-privileged-lanes--01a1837fddb9.md).

## Stage 2: the runner

* The runner stops when `/opt/bootstrap/.bootstrap/bin/ansible-playbook` does not exist. It does not use a different method.
* The runner stops when `_REMOTE_USER` or `_REMOTE_USER_HOME` is not set. The devcontainer CLI sets them.
* The runner adds three extra-vars: `_target_username`, `_target_user_home` and `_target_arch` (`amd64` or `arm64`).
* The runner sets `ANSIBLE_HOME`, `ANSIBLE_REMOTE_TMP` and `ANSIBLE_LOCAL_TEMP` to `/tmp/ansible-bootstrap`. Thus Ansible writes no files in the home directory.
* The runner sets `ANSIBLE_ROLES_PATH` to the current directory. The CLI runs `install.sh` from the feature directory, so Ansible finds `ansible-role-feature` there.

## Stage 3: the role

* `site.yml` runs on the host group `devcontainer` with `become: false`. It asserts that `feature_role` is set, then includes that role.
* The role asserts the variant, the runner contract and its parameters. Then it installs and verifies the version. See [Role contract](/architecture/role-contract--01a1837fddd1.md).

## Exception

The `bootstrap` feature has a plain bash `install.sh`. It cannot use Ansible, because it installs Ansible. See [Bootstrap environment](/architecture/bootstrap-environment--01a1837fdda1.md).

## Related

* [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md)
* [ADR-002: Ansible as the feature installer](/decisions/adr-002-ansible-as-the-feature-installer--01a1838011ad.md)
* [Bootstrap environment](/architecture/bootstrap-environment--01a1837fdda1.md)
* [Userland and privileged lanes](/architecture/userland-and-privileged-lanes--01a1837fddb9.md)
* [Role contract](/architecture/role-contract--01a1837fddd1.md)
* [Decisions overview](/decisions/decisions-overview--01a1837af6ce.md) — ADR-002, ADR-008 and ADR-012.
* [Architecture overview](/architecture/architecture-overview--01a1837af69f.md)
