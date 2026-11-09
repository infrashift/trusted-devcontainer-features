---
id: "01a1bf26-5536-7948-8d90-b43df8777fdb"
title: "Feature: redis-cli"
type: "feature"
tags:
  - "feature"
  - "redis-cli"
  - "valkey"
created: "2026-11-09T01:12:02-06:00"
timestamp: "2026-11-09T01:12:13-06:00"
description: "The redis-cli feature installs valkey-cli from the pinned Valkey release tarball for amd64 or arm64 and links redis-cli to it."
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/features/redis-cli.mdx"
generated:
  by: "claude-code/opus-5-5"
  at: "2026-11-09T01:12:13-06:00"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/redis-cli/devcontainer-feature.json"
    title: "redis-cli devcontainer-feature.json"
  - resource: "https://valkey.io/download/"
    title: "Valkey downloads"
---

# Feature: redis-cli

# Feature: redis-cli

The `redis-cli` feature installs `valkey-cli` from the official Valkey release tarball and links `redis-cli` to it. `valkey-cli` speaks the Redis protocol (RESP2 and RESP3) and accepts the `redis-cli` flags. The binary goes into `~/.local/share/valkey/<version>/`, with the links `redis-cli` and `valkey-cli` in `~/.local/bin`. The feature is in the userland lane.

## Options

Feature version 1.0.0. The defaults are from `src/redis-cli/devcontainer-feature.json` on 2026-11-09.

| Option | Default | Use |
|---|---|---|
| `target_version` | `9.1.3` | The Valkey release version. |
| `target_checksum` | empty | Empty: use the pinned SHA256 for the version and the architecture. Required for a version that has no pin. |

## Architectures

The runner injects `_target_arch` as `amd64` or `arm64`. Valkey names its tarballs `x86_64` and `arm64`. Thus `vars/main.yml` maps `amd64` to `x86_64` in `_redis_cli_arch_map`. The pinned checksum map is keyed by `_target_arch`.

The role uses the `jammy` build. On 2026-11-09, `valkey-cli` 9.1.3 needed only `libc`, `libm`, `libssl.so.3` and `libcrypto.so.3`, and its highest glibc symbol was `GLIBC_2.34`. Thus it runs on `ubi9`, `ubi10` and `fedora43`. The `noble` build needs glibc 2.39, which `ubi9` does not have.

CI builds the `infra` test template on native `amd64` (`ubuntu-latest`) and `arm64` (`ubuntu-24.04-arm`) runners.

## Decision

The feature uses Valkey release binaries for these reasons (2026-11-09):

* Redis publishes no prebuilt CLI binaries. Only source tarballs and distribution packages are available.
* Fedora 43 replaced its `redis` package with Valkey. The `valkey-compat-redis` RPM supplies `redis-cli`, but a `dnf` install cannot pin the version, and it needs the privileged lane.
* A build from source needs a compiler in the image.
* Valkey publishes a tarball for each architecture with a `.sha256` file. Thus the role can pin a version and a checksum ([ADR-006: Checksum verification](/decisions/adr-006-checksum-verification--01a183801256.md)).

The role extracts only `valkey-cli` and the `LICENSE` file. It does not install the server, sentinel or benchmark binaries.

## Version output

`redis-cli --version` prints `valkey-cli <version> (git:<sha>)`. The role and `test-templates/infra/tests.sh` compare the full version token.

## Add a version

The procedure is in `src/redis-cli/NOTES.md`. Make sure that the highest `GLIBC_` symbol of the new `valkey-cli` is 2.34 or lower. If it is higher, remove `ubi9` from the compatibility list.

## Dependencies

* `dependsOn`: `./bootstrap`. The runtime installs [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) first ([ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md)).
* `installsAfter`: none.

## Test templates

The test template `infra` in `test-templates/` uses this feature.

## Related

* [Feature: jq](/features/feature-jq--01a183800ef7.md) — the same pinned-checksum shape.
* [Install paths](/architecture/install-paths--01a1837fde1b.md)
* [Role contract](/architecture/role-contract--01a1837fddd1.md)
* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
