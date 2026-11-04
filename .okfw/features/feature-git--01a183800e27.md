---
id: "01a18380-0e27-7b91-8d13-4b67de746eb4"
title: "Feature: git"
type: "feature"
tags:
  - "feature"
  - "git"
  - "rpm"
created: "2026-10-28T12:12:49-05:00"
timestamp: "2026-10-28T12:17:21-05:00"
description: "The git feature installs the git RPM of the distribution with dnf5 in the privileged lane; it has no options."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:21-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/features/git.mdx"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/git/devcontainer-feature.json"
    title: "git devcontainer-feature.json"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/tree/main/src/git/ansible-role-feature"
    title: "git Ansible role"
---

# Feature: git

The `git` feature installs the `git` RPM of the distribution. Its `install.sh` calls the runner with `--privileged`, and the role includes `/opt/bootstrap/tasks/install-packages.yml`, which runs `dnf5`. The role verifies the install with `git --version`. A package install has no requested version, so a name match is the version check ([ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md)).

## Options

Feature version 1.4.2. The defaults are from `src/git/devcontainer-feature.json` on 2026-10-28.

The feature has no options.

## Dependencies

* `dependsOn`: `./bootstrap`. The runtime installs [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) first ([ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md)).
* `installsAfter`: none.

## Test templates

The test templates `ansible-cue`, `dotnet-node`, `go-cue`, `java`, `python` in `test-templates/` use this feature.

## Notes

* The docs page says that the feature compiles Git from source. The code installs the RPM with `dnf5`.
* The description in `devcontainer-feature.json` says "Redhat UBI". The role also supports `fedora43` ([ADR-010: Fedora 43 target](/decisions/adr-010-fedora-43-target--01a183801309.md)).

## Related

* [Feature docs pages disagree with the code](/issues/feature-docs-pages-disagree-with-the-code--01a183894c2e.md)
* [Feature: git-lfs](/features/feature-git-lfs--01a183800e4e.md)
* [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) — supplies `install-packages.yml`.
* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md) — the privileged lane.
* [ADR-010: Fedora 43 target](/decisions/adr-010-fedora-43-target--01a183801309.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
