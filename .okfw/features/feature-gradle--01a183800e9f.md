---
id: "01a18380-0e9f-7ad0-b413-01c454637d34"
title: "Feature: gradle"
type: "feature"
tags:
  - "feature"
  - "gradle"
  - "java"
created: "2026-10-28T12:12:50-05:00"
timestamp: "2026-10-28T12:17:21-05:00"
description: "The gradle feature installs Gradle from services.gradle.org, verified against a pinned SHA256 checksum; it needs a JDK."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:21-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/features/gradle.mdx"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/gradle/devcontainer-feature.json"
    title: "gradle devcontainer-feature.json"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/tree/main/src/gradle/ansible-role-feature"
    title: "gradle Ansible role"
---

# Feature: gradle

The `gradle` feature installs Gradle from `services.gradle.org`. The role verifies `gradle-<version>-bin.zip` against a pinned SHA256 checksum. One checksum covers both architectures. It extracts into `~/.local/share/gradle/gradle-<version>/` and links `gradle` into `~/.local/bin`. If the JDK of the `openjdk` feature exists, the role sets `JAVA_HOME` for the version check.

## Options

Feature version 1.2.0. The defaults are from `src/gradle/devcontainer-feature.json` on 2026-10-28.

| Option | Default | Use |
|---|---|---|
| `target_version` | `9.8.2` | The Gradle version, `X.Y` or `X.Y.Z`. |
| `target_checksum` | empty | Empty: use the pinned checksum. Required for a version that has no pin. |

## Dependencies

* `dependsOn`: `./bootstrap`. The runtime installs [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) first ([ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md)).
* `installsAfter`: `./openjdk`. This sets the order only. It does not install the other feature.
* Gradle needs a JDK. Add the `openjdk` feature, or supply a system JDK on `PATH`.

## Test templates

The test template `java` in `test-templates/` uses this feature.

## Related

* [Feature: openjdk](/features/feature-openjdk--01a18380102a.md)
* [Feature: maven](/features/feature-maven--01a183800f7a.md) — the same shape.
* [ADR-006: Checksum verification](/decisions/adr-006-checksum-verification--01a183801256.md)
* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
