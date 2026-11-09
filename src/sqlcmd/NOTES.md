# sqlcmd Feature

Installs [go-sqlcmd](https://github.com/microsoft/go-sqlcmd), the current Microsoft `sqlcmd` for SQL Server, Azure SQL and Fabric. It accepts the flags of the legacy ODBC `sqlcmd` and adds the `sqlcmd config`, `sqlcmd query` and `sqlcmd create` subcommands.

## Why go-sqlcmd

* It is one statically linked Go binary. It needs no ODBC driver and no shared library, so it runs on UBI 9, UBI 10 and Fedora 43.
* Microsoft publishes a release tarball for `amd64` and `arm64`. This role pins the version and the SHA256 for each architecture (ADR-006).
* The legacy `sqlcmd` (`mssql-tools18`) needs the Microsoft dnf repository, `msodbcsql18`, `unixODBC`, an EULA acceptance (`ACCEPT_EULA=Y`) and the privileged lane. A dnf install cannot pin its checksum.

## Install Location

- Binary: `~/.local/share/sqlcmd/<version>/sqlcmd` (with `NOTICE.md`)
- Link: `~/.local/bin/sqlcmd`

`sqlcmd_debug` is not installed.

## Extraction

The release is a `.tar.bz2`. `ansible.builtin.unarchive` runs `tar -j`, which needs a `bzip2` binary that the minimal base images do not have. The role extracts the two members with the `tarfile` module of the runner's own Python and the `data` filter.

## Version output

`sqlcmd --version` prints a banner with the line `Version: v<version>`. The role and the tests compare that full line.

## Add a version

go-sqlcmd publishes no checksum file. Use the digest that GitHub records for each release asset, and compare it with the downloaded file:

```bash
v=<ver>
gh api repos/microsoft/go-sqlcmd/releases/tags/v$v \
  --jq '.assets[] | select(.name|test("^sqlcmd-linux-(amd64|arm64)\\.tar\\.bz2$")) | "\(.digest) \(.name)"'
for a in amd64 arm64; do
  curl -fsSLO https://github.com/microsoft/go-sqlcmd/releases/download/v$v/sqlcmd-linux-$a.tar.bz2
done
sha256sum sqlcmd-linux-*.tar.bz2      # must equal the digests above
tar tjf sqlcmd-linux-amd64.tar.bz2    # must still hold sqlcmd and NOTICE.md at the top level
```

Add the two digests to `_sqlcmd_pinned_checksums` in `ansible-role-feature/vars/main.yml`, keyed by `amd64` and `arm64`.

## Versions

See the releases at https://github.com/microsoft/go-sqlcmd/releases
