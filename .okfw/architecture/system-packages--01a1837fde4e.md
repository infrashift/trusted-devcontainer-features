---
id: "01a1837f-de4e-7ce9-ace6-06b1b4a1acf0"
title: "System packages"
type: "component"
tags:
  - "architecture"
  - "system-packages"
  - "dnf5"
created: "2026-10-28T12:12:37-05:00"
timestamp: "2026-10-28T12:20:26-05:00"
description: "Privileged roles install RPMs through /opt/bootstrap/tasks/install-packages.yml, which calls dnf5; shared libraries stay in the base image."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:26-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/bootstrap/assets/tasks/install-packages.yml"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/test-templates/shared/Containerfile"
    title: "Shared test Containerfile"
---

# System packages

A role cannot use the Ansible `package` or `dnf5` module. These modules import the `libdnf5` Python bindings, and only the system Python has them. The `.bootstrap` venv cannot see them. Thus a privileged role includes the shared task file `/opt/bootstrap/tasks/install-packages.yml`.

## Usage

```yaml
- name: Install system packages
  ansible.builtin.include_tasks: /opt/bootstrap/tasks/install-packages.yml
  vars:
    _packages:
      - git
```

## What the task file does

1. It asserts that `_packages` is a list that is not empty.
2. It runs `rpm -q` on the packages. When all are installed, it does nothing more. Thus a second run reports `changed=0`.
3. It runs `dnf5 -y install --setopt=install_weak_deps=False`.
4. It runs `dnf5 clean packages`. It does not run `clean all`, because the next feature then must download the repository metadata again.
5. It runs `rpm -q` again to verify.

On 2026-10-28, the roles of `git`, `git-lfs`, `make` and `sshd` use it.

## Packages in the base image

Shared runtime libraries are in the base image, not in a feature: `unzip`, `libicu` and `openssl-libs`. Thus `bun`, `openjdk` and `dotnet` stay in the userland lane. The base image also installs `tar`, `gzip`, `curl` and `util-linux`. `util-linux` supplies `setpriv`.

## Related

* [Userland and privileged lanes](/architecture/userland-and-privileged-lanes--01a1837fddb9.md)
* [Bootstrap environment](/architecture/bootstrap-environment--01a1837fdda1.md)
* [Test templates](/architecture/test-templates--01a1837fde68.md) — the shared Containerfile.
* [Architecture overview](/architecture/architecture-overview--01a1837af69f.md)
