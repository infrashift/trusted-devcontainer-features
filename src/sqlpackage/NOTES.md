# SqlPackage Feature

Installs [SqlPackage](https://learn.microsoft.com/sql/tools/sqlpackage/sqlpackage),
the DacFx command line, on Red Hat UBI DevContainers. SqlPackage deploys a
DACPAC (schema) and exports or imports a BACPAC (schema and data).

## Install Location

- SqlPackage: `~/.local/share/sqlpackage/`
- Wrapper: `~/.local/bin/sqlpackage`

**A wrapper, not a symlink.** Every other tool in this line is a self-contained
binary that a symlink suffices for. SqlPackage is a .NET **apphost**: it locates
its runtime through `DOTNET_ROOT`, and the dotnet feature installs the SDK under
`$HOME/.local/share/dotnet`, which the apphost does not probe. Without it:

```
You must install .NET to run this application.
App host version: 8.0.30 / .NET location: Not found
Failed to resolve libhostfxr.so [not found]
```

The seed's image exports `DOTNET_ROOT` from `/etc/profile.d` for **login**
shells, so a symlink appears to work in a developer's terminal and fails
everywhere else — during the feature install itself, in `ssh host sqlpackage …`,
in any script with a plain shell. The wrapper carries the location with the tool
rather than relying on the caller's environment.

**It sets `DOTNET_ROOT` unconditionally, and that is deliberate.** 1.0.1 wrote
`${DOTNET_ROOT:-…}`, honouring an inherited value — which sounds courteous and
was the bug. The `dotnet` feature's `containerEnv` hardcodes
`DOTNET_ROOT=/home/dev/.local/share/dotnet`, so during a devcontainer build the
variable is already set, to an account most images do not have. The default
never applied, the apphost looked under `/home/dev`, and it exited 131 with
*".NET location: Not found"* while the SDK sat in the target user's home. This
feature asserts the SDK's real location before installing; that is the location
the wrapper uses, whatever the environment claims.

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

## Why CI did not catch this

The `dotnet-node` test template runs as **`dev`**, and the `dotnet` feature's
`containerEnv` hardcodes `DOTNET_ROOT=/home/dev/.local/share/dotnet` — correct
for that account, and carried by `devcontainer exec`. So the template's
`check "sqlpackage" sqlpackage /version` passed against a build that could not
run in a real workspace.

A real seed uses **`user`**, where that path does not exist, and reaches the tool
over SSH, where sshd strips the environment before a login shell rebuilds it.
The seed's own Containerfile records the general rule: *"a feature's
containerEnv is metadata for the container the CLI would start, not for an SSH
session."*

The consequence is worth stating for the next feature: **anything that depends
on `containerEnv` or on the `/home/dev` path passes this repository's CI and
fails in a workspace.** A tool should carry what it needs, as this one now does.
