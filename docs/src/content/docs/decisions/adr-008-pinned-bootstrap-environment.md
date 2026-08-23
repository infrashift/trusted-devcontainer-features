---
title: "ADR-008: Pinned .bootstrap UV Environment"
description: Decision to replace the ephemeral uv run Ansible runner with a pinned, root-owned virtual environment.
---

**Status:** Accepted — supersedes [ADR-004](/trusted-devcontainer-features/decisions/adr-004-uv-as-ansible-runner/)

## Context

[ADR-004](/trusted-devcontainer-features/decisions/adr-004-uv-as-ansible-runner/) chose `uv run --with ansible-core` so that ansible-core never had to be installed permanently. Three things have since undermined that choice.

**The base image no longer ships Python.** Templates now build on `fedora43-minimal`, which contains no `python3` at all. Ansible's `local` connection spawns a subprocess using a discovered interpreter, and with nothing to discover the run fails before any task executes. An interpreter at a known, fixed path is now a hard requirement, not a convenience.

**`--with ansible-core` is an unpinned dependency.** It resolves whatever ansible-core PyPI considers current *at image build time*. Two builds of the same commit can install different Ansible versions. That is difficult to defend in a project whose base images are digest-pinned, whose artifacts are cosign-signed, and whose releases ship SBOMs and SLSA provenance. The bootstrapper was the least trustworthy link in an otherwise pinned chain.

**The cost is paid per feature.** Each of the 21 features re-resolved and re-installed ansible-core.

## Decision

Install a persistent, pinned virtual environment at **`/opt/bootstrap/.bootstrap`**, provisioned by the `bootstrap` feature ([ADR-009](/trusted-devcontainer-features/decisions/adr-009-mandatory-dependencies/)):

- `uv` itself is installed from a pinned release tarball and **SHA256-verified** before use.
- The environment is built on a uv-managed CPython pinned by the `python_version` option (default 3.12).
- `ansible-core` is pinned by the `ansible_core_version` option (default 2.18.2).
- The interpreter path is published to Ansible as `ansible_python_interpreter` in the generated inventory, so nothing is left to discovery.

`UV_PYTHON_INSTALL_DIR` is set to `/opt/bootstrap/python`. uv's default is `~/.local/share/uv/python`, which for root is under `/root` (mode `0700`) — the venv interpreter would be unreadable by the unprivileged user that actually runs the playbooks.

The whole tree is **root-owned and world-readable**. The developer executes the provisioning toolchain but cannot modify it. This is the privilege separation that matters: not *which* unprivileged account runs Ansible, but whether the account being provisioned can rewrite the thing doing the provisioning.

## Consequences

- **Positive**: Reproducible. The same commit yields the same Ansible on every build.
- **Positive**: ansible-core, its dependencies, and the CPython build appear in the image SBOM and are scanned by Grype.
- **Positive**: Resolution happens once, not 21 times.
- **Positive**: Works on a base image with no system Python.
- **Positive**: `uv` is verified against a pinned checksum rather than piped from `curl | sh`.
- **Negative**: Permanent image size cost — a CPython runtime plus ansible-core, which ADR-004 explicitly set out to avoid.
- **Negative**: Bumping ansible-core is now a deliberate, reviewable change rather than something that drifts silently. This is the point, but it is maintenance.
- **Negative**: Features are coupled to a base layer providing `/opt/bootstrap`. The runner hard-fails with a clear message when it is absent rather than falling back to an unpinned path.

## Alternatives Considered

- **Keep `uv run --with ansible-core`, pin with `--with ansible-core==X`**: Would fix reproducibility but not the missing interpreter, and still pays resolution cost 21 times.
- **Install ansible-core into the target user's home**: Makes the toolchain writable by the account it provisions.
- **System Python + `pip install`**: Requires adding Python to a minimal base image, and reintroduces unpinned resolution unless a lockfile is added anyway.
