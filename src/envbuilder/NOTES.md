# envbuilder Feature

Installs [envbuilder](https://github.com/coder/envbuilder) as `envbuilder` on `PATH`. envbuilder
builds a development environment from a repository's `devcontainer.json` or Dockerfile, inside a
running container, without a Docker daemon.

## OS Support

Red Hat UBI9/UBI10 and Fedora 43. `bash` is required to execute `install.sh`. Installation is
orchestrated by `/opt/bootstrap/run-feature.sh`, provided by the `bootstrap` feature.

## Where the binary comes from

envbuilder publishes **no release binaries** — its container image is the only distribution channel.
That image is a single layer containing just the binary, so this feature downloads exactly one blob
and needs no container runtime to do it.

An OCI blob is addressed by the sha256 of its own bytes. The pinned digest is therefore both the
download URL and the checksum that verifies it — the same value on both sides, which is what keeps
this inside ADR-006 without introducing any new verification machinery.

Digests are pinned per version **and per architecture** in the role's `_envbuilder_pinned_layers`
map. To install an unpinned version or architecture, supply `target_checksum`; leaving it empty for
an unpinned version is a named error, not a silent skip of verification.

Note that envbuilder's image tags carry **no `v` prefix** (`1.3.0`, not `v1.3.0`), unlike kaniko's.

## Reading the installed version

You cannot ask envbuilder its version without running it. `envbuilder version` prints
`envbuilder v1.3.0+<commit> - Build development environments…` and then proceeds to attempt a build;
a bogus subcommand produces byte-identical output, because that line is simply its startup banner.

So the binary is installed under a version-scoped prefix, `~/.local/share/envbuilder/<version>/`,
with a symlink into `~/.local/bin`. The prefix is what makes the installed version legible, and the
pinned layer digest is what proves it. The role never executes the binary.

## Using it

envbuilder is configured entirely through `ENVBUILDER_*` environment variables rather than flags in
normal use, and it is designed to run as a container's **entrypoint** rather than as an interactive
command. The most commonly used variables:

| Variable | Purpose |
| --- | --- |
| `ENVBUILDER_GIT_URL` | Repository to clone and build |
| `ENVBUILDER_INIT_SCRIPT` | Command run after the build completes |
| `ENVBUILDER_DEVCONTAINER_DIR` | Where to look for `devcontainer.json` |
| `ENVBUILDER_CACHE_REPO` | Registry to push/pull the layer cache |
| `ENVBUILDER_BASE_IMAGE_CACHE_DIR` | Read-only directory holding a warmed base image |

Run `envbuilder --help` for the full list; every flag has a matching `ENVBUILDER_*` variable.

Be aware that running `envbuilder` with no configuration in an interactive shell will start a build
against the current workspace and write to `/.envbuilder` — as the unprivileged `dev` user that
fails on permissions rather than doing damage, but it is not a no-op command.

## Example Usage

```json
// devcontainer.json
"features": {
    "ghcr.io/infrashift/trusted-devcontainer-features/envbuilder": {}
}
```
