# SqlPackage Feature

Installs [SqlPackage](https://learn.microsoft.com/sql/tools/sqlpackage/sqlpackage),
the DacFx command line, on Red Hat UBI DevContainers. SqlPackage deploys a
DACPAC (schema) and exports or imports a BACPAC (schema and data).

## Install Location

- SqlPackage: `~/.local/share/sqlpackage/`
- Symlink: `~/.local/bin/sqlpackage`

The command is `sqlpackage`, lower case. `SqlPackage` is the .NET Framework
spelling for Windows and does not resolve on Linux.

## Requires the dotnet feature

SqlPackage is a .NET tool, so the SDK must already be on disk. Declare the
`dotnet` feature alongside this one. `installsAfter` orders the two; it does not
add the dotnet feature for you, and this role fails by name if the SDK is
absent.

**The pin must name a release that publishes a `net8.0` asset.**
`microsoft.sqlpackage` is a `DotnetTool` package whose nuspec declares one
dependency group per target framework — 170.5.76 declares both `net10.0` and
`net8.0` — so `dotnet tool install` resolves the `net8.0` one against an SDK 8
image. Microsoft's download page says SqlPackage is "built using .NET 10", which
describes the standalone zip and not this package. A pin with only a `net10.0`
asset installs cleanly and then fails at first run with *"You must install or
update .NET"*; the role's verify assert catches that at build time rather than
in a developer's workspace.

## Network

The install reaches **`api.nuget.org` and nothing else**.

It deliberately does not fetch the standalone zip from `aka.ms/sqlpackage-linux`.
Behind a filtering egress proxy that would take two allow-list entries rather
than one — `aka.ms` is a redirector, and the exact-match `dstdomain` rule needs
whatever it redirects to as well — and `api.nuget.org` is already permitted
wherever a workspace runs `dotnet restore`.

## No pinned checksum, and why

Every role in this repository that fetches a release tarball pins a per-arch
SHA256 and hands it to `get_url`, which `check-role-contract.sh` invariant 8
enforces — for `get_url`. This role installs through `dotnet tool install`,
which resolves and verifies the package through NuGet's own machinery, so there
is no URL to pin and no digest to carry. `src/uv-ruff` has the same shape for
`uv tool install ruff`; this is the second instance rather than a new idea.

What stands in for the pin:

- an exact `--version`, never a floating range, with an `X.Y.Z` shape assert so
  a malformed value cannot become one;
- an assert on the version the installed binary reports, so the release that
  actually landed is the release that was asked for.

## Versions

See available versions at https://www.nuget.org/packages/Microsoft.SqlPackage

## Example Usage

```json
// devcontainer.json
"features": {
    "./dotnet": {},
    "./sqlpackage": {"target_version": "170.5.76"}
}
```
