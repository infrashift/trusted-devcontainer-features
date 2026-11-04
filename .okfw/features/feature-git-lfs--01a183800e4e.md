---
id: "01a18380-0e4e-7c1c-bfbf-2fe48171e4c1"
title: "Feature: git-lfs"
type: "feature"
tags:
  - "feature"
  - "git-lfs"
  - "rpm"
created: "2026-10-28T12:12:49-05:00"
timestamp: "2026-10-28T12:17:21-05:00"
description: "The git-lfs feature installs the git-lfs RPM of the distribution with dnf5 in the privileged lane; it has no options."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:21-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/features/git-lfs.mdx"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/git-lfs/devcontainer-feature.json"
    title: "git-lfs devcontainer-feature.json"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/tree/main/src/git-lfs/ansible-role-feature"
    title: "git-lfs Ansible role"
---

# Feature: git-lfs

The `git-lfs` feature installs the `git-lfs` RPM of the distribution. Its `install.sh` calls the runner with `--privileged`, and the role includes `/opt/bootstrap/tasks/install-packages.yml`, which runs `dnf5`. The role verifies the install with `git-lfs --version`.

## Options

Feature version 1.4.2. The defaults are from `src/git-lfs/devcontainer-feature.json` on 2026-10-28.

The feature has no options.

## Dependencies

* `dependsOn`: `./bootstrap`. The runtime installs [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) first ([ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md)).
* `installsAfter`: `./git`. This sets the order only. It does not install the other feature.

## Test templates

The test templates `ansible-cue`, `dotnet-node`, `go-cue`, `java`, `python` in `test-templates/` use this feature.

## Notes

* The docs page says that the role downloads a tarball from GitHub and that Git is compiled from source. The code installs the RPM with `dnf5`.

## Related

* [Feature: git](/features/feature-git--01a183800e27.md)
* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md) — the privileged lane.
* [Features overview](/features/features-overview--01a1837af6b6.md)
