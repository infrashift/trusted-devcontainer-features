---
id: "01a1837f-de68-7124-9eb1-3ae4f5b4b014"
title: "Test templates"
type: "component"
tags:
  - "architecture"
  - "testing"
  - "test-templates"
created: "2026-10-28T12:12:37-05:00"
timestamp: "2026-10-28T12:20:27-05:00"
description: "Seven dev containers in test-templates/ build the working-tree features on the shared Containerfile and run smoke tests in tests.sh."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:27-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/tree/main/test-templates"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/test-templates/shared/test-lib.sh"
    title: "test-lib.sh"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/Makefile"
    title: "Makefile"
---

# Test templates

A test template is one dev container in `test-templates/<name>/`. It installs the features from the working tree, not from the registry. CI and `make test-template` copy `src/*` into `test-templates/<name>/.devcontainer/` first, so that each `./<id>` reference resolves.

## The templates

All templates build from `test-templates/shared/Containerfile`, which uses the digest-pinned `trusted/fedora43-minimal` base image. Each template also lists `./bootstrap`.

| Template | Features (besides `bootstrap`) | User |
|---|---|---|
| `ansible-cue` | `ansible-core`, `python`, `cuelang`, `git`, `git-lfs`, `grype`, `syft`, `jq`, `yq` | `dev` |
| `dotnet-node` | `make`, `dotnet`, `sqlpackage`, `nodejs`, `npm`, `pnpm`, `git`, `git-lfs`, `grype`, `syft`, `jq`, `yq` | `user`, GID 0 |
| `extras` | `nodejs`, `bun`, `claude-code`, `openai-codex` | `dev` |
| `go-cue` | `golang`, `cuelang`, `git`, `git-lfs`, `grype`, `syft`, `jq`, `yq` | `dev` |
| `infra` | `kaniko`, `envbuilder`, `sshd`, `redis-cli` | `dev` |
| `java` | `openjdk`, `maven`, `gradle`, `git`, `git-lfs`, `grype`, `syft`, `jq`, `yq` | `dev` |
| `python` | `python`, `uv-ruff`, `git`, `git-lfs`, `grype`, `syft`, `jq`, `yq` | `dev` |

Read the current lists in `test-templates/<name>/.devcontainer/devcontainer.json`.

## Two kinds of test

| Kind | File | Runs as | Checks |
|---|---|---|---|
| Smoke | `test-templates/<name>/tests.sh` | the dev user, with `devcontainer exec` | Each tool runs and, for some tools, has the pinned version or path |
| Contract | `test-templates/shared/contract-tests.sh` | root, with `docker exec -u 0` | Idempotency and failure modes. See [Contract tests](/architecture/contract-tests--01a1837fde81.md). |

`tests.sh` uses `check` and `report_results` from `test-templates/shared/test-lib.sh`.

## Option values in a template

Some templates set an option, for example `ansible-core` `target_version`. Each such value must be a declared default. The [Version pins check](/supply-chain/version-pins-check--01a1837fdfc3.md) enforces this.

## Related

* [The test templates used an account that no seed uses](/issues/the-test-templates-used-an-account-that-no-seed-uses--01a18382611a.md)
* [The make test targets called a test tree that did not exist](/issues/the-make-test-targets-called-a-test-tree-that-did-not-exist--01a1838263e4.md)
* [Contract tests](/architecture/contract-tests--01a1837fde81.md)
* [Test Features in Templates workflow](/supply-chain/test-features-in-templates-workflow--01a1837fded2.md)
* [Test one template locally](/operations/test-one-template-locally--01a1837fe195.md)
* [Dev user](/architecture/dev-user--01a1837fde35.md)
* [Architecture overview](/architecture/architecture-overview--01a1837af69f.md)
