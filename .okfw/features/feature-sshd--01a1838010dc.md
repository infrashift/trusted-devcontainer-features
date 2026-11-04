---
id: "01a18380-10dc-748d-a1c9-bb1db179640f"
title: "Feature: sshd"
type: "feature"
tags:
  - "feature"
  - "sshd"
  - "rpm"
created: "2026-10-28T12:12:50-05:00"
timestamp: "2026-10-28T12:17:22-05:00"
description: "The sshd feature installs and hardens an OpenSSH server for public-key access; it is the only feature with an entrypoint."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:22-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/features/sshd.mdx"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/sshd/devcontainer-feature.json"
    title: "sshd devcontainer-feature.json"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/tree/main/src/sshd/ansible-role-feature"
    title: "sshd Ansible role"
---

# Feature: sshd

The `sshd` feature installs the `openssh-server` RPM and sets it for public-key access to the dev user only. It runs in the privileged lane. It writes `/etc/ssh/sshd_config.d/10-trusted-devcontainer.conf`, which disables passwords and root login. It also writes a rootless sshd configuration. It is the only feature with an `entrypoint`, `/usr/local/share/ssh-init.sh`, which starts sshd and reads the authorized keys at each container start.

## Options

Feature version 1.1.2. The defaults are from `src/sshd/devcontainer-feature.json` on 2026-10-28.

| Option | Default | Use |
|---|---|---|
| `sshd_port` | `2222` | The port of sshd. |
| `authorized_keys_path` | `/run/secrets/authorized_keys` | The file that the entrypoint reads at start. |

The image does not contain authorized keys. The container starts with a warning if the file is missing.

## Dependencies

* `dependsOn`: `./bootstrap`. The runtime installs [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) first ([ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md)).
* `installsAfter`: none.

## Test templates

The test template `infra` in `test-templates/` uses this feature.

## Notes

* The docs page says that only `git` and `git-lfs` also use the privileged lane. `make` also uses it.

## Related

* [Feature docs pages disagree with the code](/issues/feature-docs-pages-disagree-with-the-code--01a183894c2e.md)
* [Feature: make](/features/feature-make--01a183800f4f.md) — another privileged feature.
* [ADR-011: dev user alignment](/decisions/adr-011-dev-user-alignment--01a183801339.md) — the dev user.
* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md) — the privileged lane.
* [Features overview](/features/features-overview--01a1837af6b6.md)
