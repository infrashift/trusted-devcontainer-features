---
id: "01a18380-0f4f-7172-b8d5-ad10ec55d558"
title: "Feature: make"
type: "feature"
tags:
  - "feature"
  - "make"
  - "rpm"
created: "2026-10-28T12:12:50-05:00"
timestamp: "2026-10-28T12:17:21-05:00"
description: "The make feature installs the make RPM of the distribution in the privileged lane, so that make all works in a workspace."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:21-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/features/make.mdx"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/make/devcontainer-feature.json"
    title: "make devcontainer-feature.json"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/tree/main/src/make/ansible-role-feature"
    title: "make Ansible role"
---

# Feature: make

The `make` feature installs the `make` RPM of the distribution at `/usr/bin/make`. The base images have no `make`, so a workspace could not run `make all`. Its `install.sh` calls the runner with `--privileged`, and the role includes `/opt/bootstrap/tasks/install-packages.yml`.

## Options

Feature version 1.0.2. The defaults are from `src/make/devcontainer-feature.json` on 2026-10-28.

The feature has no options.

## Dependencies

* `dependsOn`: `./bootstrap`. The runtime installs [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) first ([ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md)).
* `installsAfter`: none.

## Test templates

The test template `dotnet-node` in `test-templates/` uses this feature.

## Related

* [Workspace images had no make](/issues/workspace-images-had-no-make--01a183826263.md)
* [Feature: git](/features/feature-git--01a183800e27.md) — the same privileged RPM shape.
* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md) — the privileged lane.
* [Features overview](/features/features-overview--01a1837af6b6.md)
