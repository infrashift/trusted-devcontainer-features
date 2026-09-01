# kaniko Feature

Installs the [kaniko](https://github.com/osscontainertools/kaniko) executor and cache warmer as
`kaniko-executor` and `kaniko-warmer` on `PATH`.

Upstream is the `osscontainertools/kaniko` community fork, which succeeded the archived
`GoogleContainerTools/kaniko`. It is the same upstream the infrashift Guix channel packages.

## OS Support

Red Hat UBI9/UBI10 and Fedora 43. `bash` is required to execute `install.sh`. Installation is
orchestrated by `/opt/bootstrap/run-feature.sh`, provided by the `bootstrap` feature.

## Where the binaries come from

kaniko publishes **no release binaries** — container images are its only distribution channel, and
upstream states plainly that "kaniko is meant to be run as an image." Each binary happens to occupy
its own dedicated image layer, so this feature downloads exactly one blob per binary instead of
unpacking an image, and needs no container runtime to do it.

An OCI blob is addressed by the sha256 of its own bytes. The pinned digest is therefore both the
download URL and the checksum that verifies it — the same value on both sides, which is what keeps
this inside ADR-006 without introducing any new verification machinery.

Digests are pinned per version **and per architecture** in the role's `_kaniko_pinned_layers` map.
To install an unpinned version or architecture, supply `target_executor_checksum` and
`target_warmer_checksum`; leaving them empty for an unpinned version is a named error, not a silent
skip of verification.

## Reading the installed version

`kaniko-executor version` prints `Kaniko version :  v<X.Y.Z>`.

**`kaniko-warmer` cannot report its version at all** — it has no `version` subcommand, no
`--version` flag, and nothing in `--help`. Both binaries are therefore installed under a
version-scoped prefix, `~/.local/share/kaniko/<version>/`, with symlinks into `~/.local/bin`. The
prefix is what makes the installed version legible, and the pinned layer digest is what proves it.

## Running kaniko inside a dev container

**kaniko is not a normal CLI.** The executor unpacks the base image into *its own* `/` and sweeps
the root filesystem, so running it unwrapped inside this container will attempt to modify the
container's own root. This feature installs the binaries; it does not ship a wrapper that makes
that safe.

The established approach in this organization is to `chroot(2)` into a synthetic root — which needs
only `CAP_SYS_CHROOT`, not full privilege — with three stubs kaniko requires (`proc/self/mountinfo`
as an empty file, `proc/self/exe` as a symlink to the binary, and `dev/null` as a plain file), and
with `USER=root HOME=/tmp` set explicitly because the chroot has no `/etc/passwd`. See
SSHadowForge's `golden/scripts/image.sh` and `runner/sfd-build-agent.sh` in
`ansible-collection-infrashift-hashistack` for a working implementation, including the flag set and
the reasoning behind each flag.

`kaniko-warmer` has no such constraint: it only writes to the cache directory it is given.

## Example Usage

*Accept default option values:*

```json
// devcontainer.json
"features": {
    "ghcr.io/infrashift/trusted-devcontainer-features/kaniko": {}
}
```

*Pin a version that is not in the role's map:*

```json
// devcontainer.json
"features": {
    "ghcr.io/infrashift/trusted-devcontainer-features/kaniko": {
        "target_version": "1.28.3",
        "target_executor_checksum": "<sha256 of the layer holding kaniko/executor>",
        "target_warmer_checksum": "<sha256 of the layer holding kaniko/warmer>"
    }
}
```
