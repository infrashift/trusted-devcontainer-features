---
id: "01a1837f-e25c-73e6-af08-e68dae0bf3d6"
title: "Use the maintainer dev container"
type: "runbook"
tags:
  - "runbook"
  - "devcontainer"
created: "2026-10-28T12:12:38-05:00"
timestamp: "2026-10-28T12:20:27-05:00"
description: "The .devcontainer/ environment builds from the working-tree features; prepare-devcontainer.sh stages src/ into .devcontainer/ first."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:27-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/.devcontainer/devcontainer.json"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/prepare-devcontainer.sh"
    title: "scripts/prepare-devcontainer.sh"
---

# Use the maintainer dev container

The maintainer dev container in `.devcontainer/` installs the features of the working tree, so a maintainer works with the current features. The devcontainer CLI accepts a local feature only below `.devcontainer/`. Thus `scripts/prepare-devcontainer.sh` copies `src/*` into `.devcontainer/` first.

## What it contains

* Base: `.devcontainer/Containerfile`, `trusted/fedora43-minimal` pinned by digest, user `dev` 1001:1001. The build context is `.devcontainer/` only.
* Features: `bootstrap` and 19 more from the working tree. Read the list in `.devcontainer/devcontainer.json`.
* Workspace: the repository is mounted at `/workspace`.

## Procedure

1. Open the repository in an editor with Dev Containers support, or run `npx @devcontainers/cli up --workspace-folder .`.
2. The CLI runs `initializeCommand` on the host. It runs `scripts/prepare-devcontainer.sh`, which removes the old copies (not `SKELETON-feature/`) and copies `src/*` into `.devcontainer/`.
3. After you change a feature in `src/`, rebuild the container.
4. For rootless Podman, uncomment the `workspaceMount` line with `Z` and the `--userns=keep-id` run argument. Comment out the other `workspaceMount` line.

## Notes

* The copies in `.devcontainer/*/` are in `.gitignore`. `SKELETON-feature/` is tracked source.
* `.devcontainer/devcontainer.json` sets `ansible-core` to `2.18.2` on Python `3.12`, and it installs the deprecated `npm` feature (2026-10-28). The [Version pins check](/supply-chain/version-pins-check--01a1837fdfc3.md) does not read this file.

## Related

* [The maintainer dev container could not be built](/issues/the-maintainer-dev-container-could-not-be-built--01a1838263ac.md)
* [The maintainer dev container pins old versions and the deprecated npm feature](/issues/the-maintainer-dev-container-pins-old-versions-and-the-deprecated-npm-feature--01a183894d35.md)
* [Test templates](/architecture/test-templates--01a1837fde68.md)
* [Feature dependency model](/architecture/feature-dependency-model--01a1837fddea.md) — why the source uses `./<id>`.
* [Dev user](/architecture/dev-user--01a1837fde35.md)
* [Operations overview](/operations/operations-overview--01a1837af719.md)
