---
id: "01a1837f-ddb9-7185-96b0-ae242dd71425"
title: "Userland and privileged lanes"
type: "component"
tags:
  - "architecture"
  - "runner"
  - "privilege"
created: "2026-10-28T12:12:37-05:00"
timestamp: "2026-10-28T12:20:26-05:00"
description: "The runner drops to the dev user with setpriv by default; --privileged keeps root for the four features that change system state."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:26-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/bootstrap/assets/run-feature.sh"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/decisions/adr-012-feature-role-contract.md"
    title: "ADR-012"
---

# Userland and privileged lanes

The runner `/opt/bootstrap/run-feature.sh` applies a role in one of two lanes. The userland lane is the default. The `--privileged` flag selects the privileged lane.

## Userland lane

* The runner changes from root to the target user before Ansible starts. It uses `setpriv --reuid --regid --init-groups`.
* Thus each file that the role writes has the correct owner. The role needs no `become`, no `owner` and no `chown`.
* The runner does not use `su` or `runuser`. Both use PAM, and PAM fails during a container build with "failed to establish user credentials".
* `setpriv` does not pass the environment. The runner sets `HOME`, `PATH` and the three `ANSIBLE_*` variables explicitly.
* `setpriv --regid` finds the group by the user name. Thus a group with the name of the user must exist. See [Dev user](/architecture/dev-user--01a1837fde35.md).

## Privileged lane

The role runs as root. Use this lane only when the feature changes system state, for example an RPM or a file in `/etc`.

These four features pass `--privileged` in `install.sh` (2026-10-28): `git`, `git-lfs`, `make` and `sshd`. The `install.sh` of `envbuilder`, `kaniko` and `sqlpackage` names `--privileged` only in a comment, to say that it is not necessary. To find the current list, run `grep -lE '^[^#]*--privileged' src/*/install.sh`.

## Related

* [The architecture page disagrees with the code](/issues/the-architecture-page-disagrees-with-the-code--01a183826585.md)
* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md)
* [Feature install pipeline](/architecture/feature-install-pipeline--01a1837fdd88.md)
* [System packages](/architecture/system-packages--01a1837fde4e.md)
* [Role contract](/architecture/role-contract--01a1837fddd1.md)
* [Decisions overview](/decisions/decisions-overview--01a1837af6ce.md) — ADR-012.
* [Architecture overview](/architecture/architecture-overview--01a1837af69f.md)
