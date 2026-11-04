---
id: "01a1837f-e116-724e-b1e5-2ece7fbebdc8"
title: "Add a new feature"
type: "runbook"
tags:
  - "runbook"
  - "feature"
  - "role-contract"
created: "2026-10-28T12:12:38-05:00"
timestamp: "2026-10-28T12:20:27-05:00"
description: "Copy the SKELETON feature, write the metadata, install.sh and role, add a test template entry and ROLE_ARGS, then run the checks."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:27-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/reference/contributing.md"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/.devcontainer/SKELETON-feature/devcontainer-feature.json"
    title: "SKELETON-feature"
---

# Add a new feature

Use this procedure to add one feature to `src/`. `.devcontainer/SKELETON-feature/` already obeys the [role contract](/architecture/role-contract--01a1837fddd1.md). Start from it.

## Prerequisites

* A local clone, Docker, Node.js (for `npx`) and the tools in [Run the static checks and the repo gate locally](/operations/run-the-static-checks-and-the-repo-gate-locally--01a1837fe1ba.md).
* The SHA256 (or SHA512) of each upstream download, for `amd64` and `arm64`.

## Procedure

1. Copy `.devcontainer/SKELETON-feature/` to `src/<id>/`.

   WARNING: The release accepts only an id that matches `^[a-z0-9][a-z0-9-]{0,63}$`.
2. In `devcontainer-feature.json`, set `id`, `name`, `version` and `description`.
3. Give each option a `default`. Keep `"dependsOn": { "./bootstrap": {} }`.
4. Add `installsAfter` entries only for order, for example `"./nodejs"`.
5. In `install.sh`, guard each mandatory option with `${VAR:?...}`. Use `${VAR:-}` for each `*_checksum` option.
6. Pass each option to the runner with `-e "_<name>=${VAR}"`.
7. Add `--privileged` only when the role changes system state. See [Userland and privileged lanes](/architecture/userland-and-privileged-lanes--01a1837fddb9.md).
8. Keep `ansible-role-feature/defaults/main.yml` empty.
9. Put the compatibility list, the pinned checksums and the derived URLs in `vars/main.yml`.
10. In `tasks/main.yml`, keep the variant assert and the runner-contract assert. Assert each `-e` variable by name and shape.
11. Download with `get_url` and `checksum:`. Make the role idempotent. Verify the installed version in the last task.
12. Run `make check-contract`.
13. Add `"./<id>": {}` to a test template's `devcontainer.json`. Add a `check` line to its `tests.sh`.

    WARNING: If you make a new test template, also add its name to `TEMPLATES` in the `Makefile`.
14. Add a `ROLE_ARGS` entry for `<id>` in `test-templates/shared/contract-tests.sh`, with the default values.
15. Add the upstream of the tool to `latest_for` in `scripts/check-version-currency.sh`. If not, the check reports `unknown`.
16. Add `docs/src/content/docs/features/<id>.mdx`, an entry in `docs/src/data/features.json` and a row in `README.md`.
17. Run `make check`.
18. Run `make test-template TEMPLATE=<template>`, then `make test-contract TEMPLATE=<template>`.
19. Open a pull request. Make sure that `repo-gate` and `test/gate` pass.

## Result

After the merge, the [Release workflow](/supply-chain/release-workflow--01a1837fdeee.md) publishes the feature at `ghcr.io/infrashift/trusted-devcontainer-features/<id>`. The published drift check reports it as `new`.

## Related

* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md)
* [Role contract](/architecture/role-contract--01a1837fddd1.md)
* [Feature install pipeline](/architecture/feature-install-pipeline--01a1837fdd88.md)
* [Test one template locally](/operations/test-one-template-locally--01a1837fe195.md)
* [Features overview](/features/features-overview--01a1837af6b6.md)
* [Operations overview](/operations/operations-overview--01a1837af719.md)
