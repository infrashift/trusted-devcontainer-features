---
id: "01a1837f-e195-7af8-8dc6-0a19fb2ca020"
title: "Test one template locally"
type: "runbook"
tags:
  - "runbook"
  - "testing"
  - "make"
created: "2026-10-28T12:12:38-05:00"
timestamp: "2026-10-28T12:20:27-05:00"
description: "Build one test template from the working tree with make test-template, run make test-contract, then remove it with make clean."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:27-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/Makefile"
---

# Test one template locally

Use this procedure to build one [test template](/architecture/test-templates--01a1837fde68.md) from the working tree and run its tests. It does the same steps as one leg of the [Test Features in Templates workflow](/supply-chain/test-features-in-templates-workflow--01a1837fded2.md), on the architecture of your host.

## Prerequisites

* Docker, and Node.js for `npx @devcontainers/cli`.
* Access to `ghcr.io` to pull the base image.

## Procedure

1. Run `make check-contract`. It takes seconds and finds most role errors before a build.
2. Run `make test-template TEMPLATE=<name>`, for example `TEMPLATE=python`.
3. Read the smoke-test result: `Results: N/N passed`.
4. Run `make test-contract TEMPLATE=<name>`. The container from step 2 must be running.
5. Read the result. Each `SKIP` line names a feature with no `ROLE_ARGS` entry.
6. Run `make clean` to remove the test containers and the copied feature trees.

To run the static checks and all seven templates, run `make test`.

## What `make test-template` does

1. Removes the old feature copies, `devcontainer-lock.json` and each container with the label `test=<name>`.
2. Copies `src/*` into `test-templates/<name>/.devcontainer/` and `test-lib.sh` into the template.
3. Runs `devcontainer up` with `--id-label test=<name>`, then `devcontainer exec ... bash tests.sh`.

Step 1 is necessary: `devcontainer up` reuses a container with the same label and does not build again. Thus without step 1 you test old features.

## Related

* [Contract tests](/architecture/contract-tests--01a1837fde81.md)
* [Test templates](/architecture/test-templates--01a1837fde68.md)
* [Run the static checks and the repo gate locally](/operations/run-the-static-checks-and-the-repo-gate-locally--01a1837fe1ba.md)
* [Operations overview](/operations/operations-overview--01a1837af719.md)
