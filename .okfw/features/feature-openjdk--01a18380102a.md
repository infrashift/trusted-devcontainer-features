---
id: "01a18380-102a-7bc5-856c-d6d8472031bd"
title: "Feature: openjdk"
type: "feature"
tags:
  - "feature"
  - "openjdk"
  - "java"
created: "2026-10-28T12:12:50-05:00"
timestamp: "2026-10-28T12:17:21-05:00"
description: "The openjdk feature installs Eclipse Temurin OpenJDK from Adoptium in ~/.local/share/java, verified against a pinned SHA256 checksum."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:17:21-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/features/openjdk.mdx"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/openjdk/devcontainer-feature.json"
    title: "openjdk devcontainer-feature.json"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/tree/main/src/openjdk/ansible-role-feature"
    title: "openjdk Ansible role"
---

# Feature: openjdk

The `openjdk` feature installs Eclipse Temurin OpenJDK from the Adoptium GitHub releases into `~/.local/share/java`. The role verifies the tarball against a pinned SHA256 checksum. It links `java`, `javac`, `jar`, `javadoc`, `jshell` and `keytool` into `~/.local/bin`. `containerEnv` sets `JAVA_HOME` to `/home/dev/.local/share/java`.

## Options

Feature version 1.5.4. The defaults are from `src/openjdk/devcontainer-feature.json` on 2026-10-28.

| Option | Default | Use |
|---|---|---|
| `target_major_version` | `21` | The major version. The download URL uses it. |
| `target_version` | `21.0.13+9` | The full version, `X.Y.Z+B`. |
| `target_checksum` | empty | Empty: use the pinned checksum. Required for a version that has no pin. |

The two version options must agree.

## Dependencies

* `dependsOn`: `./bootstrap`. The runtime installs [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) first ([ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md)).
* `installsAfter`: none.

## Test templates

The test template `java` in `test-templates/` uses this feature.

## Related

* [Four containerEnv values name /home/dev](/issues/four-containerenv-values-name-home-dev--01a183826729.md)
* [The openjdk role rejected Adoptium four-part versions](/issues/the-openjdk-role-rejected-adoptium-four-part-versions--01a18382646a.md)
* [Feature: maven](/features/feature-maven--01a183800f7a.md)
* [Feature: gradle](/features/feature-gradle--01a183800e9f.md)
* [ADR-006: Checksum verification](/decisions/adr-006-checksum-verification--01a183801256.md)
* [ADR-011: dev user alignment](/decisions/adr-011-dev-user-alignment--01a183801339.md) — the literal path in `containerEnv`.
* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
