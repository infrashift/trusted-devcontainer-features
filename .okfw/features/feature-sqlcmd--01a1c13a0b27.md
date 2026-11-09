---
id: "01a1c13a-0b27-7cfb-aa4d-92beed62e8f4"
title: "Feature: sqlcmd"
type: "feature"
tags:
  - "feature"
  - "sqlcmd"
  - "mssql"
created: "2026-11-09T10:52:49-06:00"
timestamp: "2026-11-09T10:52:56-06:00"
description: "The sqlcmd feature installs Microsoft go-sqlcmd from the pinned GitHub release tarball for amd64 or arm64 and links sqlcmd into ~/.local/bin."
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/features/sqlcmd.mdx"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/src/sqlcmd/devcontainer-feature.json"
    title: "sqlcmd devcontainer-feature.json"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/tree/main/src/sqlcmd/ansible-role-feature"
    title: "sqlcmd Ansible role"
  - resource: "https://github.com/microsoft/go-sqlcmd/releases/tag/v1.10.0"
    title: "go-sqlcmd v1.10.0 release"
status: "draft"
generated:
  by: "claude-code/opus-5-5"
  at: "2026-11-09T10:52:56-06:00"
---

# Feature: sqlcmd

The `sqlcmd` feature installs go-sqlcmd, the current Microsoft `sqlcmd`, from the pinned GitHub release tarball. The binary goes into `~/.local/share/sqlcmd/<version>/`, with the link `sqlcmd` in `~/.local/bin`. The feature is in the userland lane.

## Options

Feature version 1.0.0. The defaults are from `src/sqlcmd/devcontainer-feature.json` on 2026-11-09.

| Option | Default | Use |
|---|---|---|
| `target_version` | `1.10.0` | The go-sqlcmd release version, without the `v` prefix. |
| `target_checksum` | empty | Empty: use the pinned SHA256 for the version and the architecture. Required for a version that has no pin. |

## Architectures

The runner injects `_target_arch` as `amd64` or `arm64`. go-sqlcmd uses the same names in its asset names (`sqlcmd-linux-amd64.tar.bz2`). Thus the role has no arch map. The pinned checksum map is keyed by `_target_arch`.

On 2026-11-09, `sqlcmd` 1.10.0 was a statically linked Go binary. It needs no glibc symbol and no shared library. Thus it runs on `ubi9`, `ubi10` and `fedora43`.

CI builds the `infra` test template on native `amd64` (`ubuntu-latest`) and `arm64` (`ubuntu-24.04-arm`) runners.

## Decision

The feature installs go-sqlcmd, not the legacy ODBC `sqlcmd`, for these reasons (2026-11-09):

* Microsoft names go-sqlcmd as the current `sqlcmd`. It accepts the flags of the legacy `sqlcmd` and adds the `config`, `query` and `create` subcommands.
* The legacy `sqlcmd` is in the `mssql-tools18` RPM. That RPM needs the Microsoft dnf repository, `msodbcsql18`, `unixODBC`, `ACCEPT_EULA=Y` and the privileged lane. A `dnf` install cannot pin a checksum.
* go-sqlcmd publishes one tarball for each architecture. Thus the role can pin a version and a checksum ([ADR-006: Checksum verification](/decisions/adr-006-checksum-verification--01a183801256.md)).

The role extracts only `sqlcmd` and `NOTICE.md`. It does not install `sqlcmd_debug`.

## Checksums

go-sqlcmd publishes no checksum file. The pinned values are the SHA256 digests that GitHub records for each release asset. On 2026-11-09, the digests of the 1.10.0 assets were the same as `sha256sum` of the downloaded tarballs.

## Extraction

The release is a `.tar.bz2`. `ansible.builtin.unarchive` runs `tar -j`, which needs a `bzip2` binary. `fedora43-minimal` and the UBI minimal images do not have `bzip2`. Thus the role runs the `tarfile` module of the runner's Python (`ansible_python_interpreter`) with the `data` filter. The filter refuses absolute paths, links out of the destination and device files. It also removes the group and other write bits that the tarball sets.

## Version output

`sqlcmd --version` prints a banner with the line `Version: v<version>`. The role and `test-templates/infra/tests.sh` compare that full line.

## Add a version

The procedure is in `src/sqlcmd/NOTES.md`. Compare the GitHub asset digest with `sha256sum` of the download. Make sure that the tarball still has `sqlcmd` and `NOTICE.md` at the top level.

## Dependencies

* `dependsOn`: `./bootstrap`. The runtime installs [Feature: bootstrap](/features/feature-bootstrap--01a183800d4f.md) first ([ADR-009: Mandatory dependencies with dependsOn](/decisions/adr-009-mandatory-dependencies-with-dependson--01a1838012db.md)).
* `installsAfter`: none. The feature does not need the `dotnet` feature.

## Test templates

The test template `infra` in `test-templates/` uses this feature.

## Related

* [Feature: sqlpackage](/features/feature-sqlpackage--01a1838010af.md) — the other SQL Server tool. It deploys DACPACs. `sqlcmd` runs queries and scripts.
* [Feature: redis-cli](/features/feature-redis-cli--01a1bf265536.md) — the same pinned-checksum shape for each architecture.
* [Install paths](/architecture/install-paths--01a1837fde1b.md)
* [Role contract](/architecture/role-contract--01a1837fddd1.md)
* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
