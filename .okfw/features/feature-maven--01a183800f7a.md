---
id: "01a18380-0f7a-73f0-acab-e61ff6d784fc"
title: "Feature: maven"
type: "feature"
tags:
  - "feature"
  - "maven"
  - "java"
created: "2026-10-28T12:12:50-05:00"
timestamp: "2026-10-28T12:17:21-05:00"
description: "The maven feature installs Apache Maven from archive.apache.org, verified against a pinned SHA512 checksum; it needs a JDK."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:21-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/features/maven.mdx"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/maven/devcontainer-feature.json"
    title: "maven devcontainer-feature.json"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/tree/main/src/maven/ansible-role-feature"
    title: "maven Ansible role"
---

# Feature: maven

The `maven` feature installs Apache Maven from `archive.apache.org`. The role verifies the tarball against a pinned SHA512 checksum, because Apache publishes SHA512 only. One checksum covers both architectures. It extracts into `~/.local/share/maven/apache-maven-<version>/` and links `mvn` into `~/.local/bin`. If the JDK of the `openjdk` feature exists, the role sets `JAVA_HOME` for the version check.

## Options

Feature version 1.2.0. The defaults are from `src/maven/devcontainer-feature.json` on 2026-10-28.

| Option | Default | Use |
|---|---|---|
| `target_version` | `3.10.0` | The Maven version. |
| `target_checksum` | empty | Empty: use the pinned SHA512 checksum (128 hex characters). |

## Dependencies

* `dependsOn`: `./bootstrap`. The runtime installs [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) first ([ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md)).
* `installsAfter`: `./openjdk`. This sets the order only. It does not install the other feature.
* Maven needs a JDK. Add the `openjdk` feature, or supply a system JDK on `PATH`.

## Test templates

The test template `java` in `test-templates/` uses this feature.

## Notes

* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md) names `dotnet` as the only SHA512 feature. `maven` also uses SHA512.

## Related

* [Feature: openjdk](/features/feature-openjdk--01a18380102a.md)
* [Feature: gradle](/features/feature-gradle--01a183800e9f.md) — the same shape.
* [ADR-006: Checksum verification](/decisions/adr-006-checksum-verification--01a183801256.md)
* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
