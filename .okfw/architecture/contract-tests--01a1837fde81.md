---
id: "01a1837f-de81-7c99-92c1-3f1ed0bd4d47"
title: "Contract tests"
type: "component"
tags:
  - "architecture"
  - "testing"
  - "role-contract"
created: "2026-10-28T12:12:37-05:00"
timestamp: "2026-10-28T12:20:27-05:00"
description: "test-templates/shared/contract-tests.sh runs each role again and requires changed=0, then checks that bad parameters fail by name."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:27-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/test-templates/shared/contract-tests.sh"
---

# Contract tests

`test-templates/shared/contract-tests.sh` tests the parts of the [role contract](/architecture/role-contract--01a1837fddd1.md) that a smoke test cannot. It runs on the host against a running test template. Usage: `contract-tests.sh <template> [container-label]`.

## How it runs

* It finds the container by the label `test=<label>`.
* It runs `/opt/bootstrap/run-feature.sh` with `docker exec -u 0`, because the runner needs root. `devcontainer exec` runs only as the dev user.
* It runs the roles from the repository mount in the container, `/workspaces/<clone directory>/src/<id>`.
* It reads the target user from `containerUser` of the template.

## Idempotency tests

For each feature in the template, the script runs the role again with the arguments in `ROLE_ARGS`. The output must contain `changed=0`. A feature with no `ROLE_ARGS` entry prints `SKIP`.

`ROLE_ARGS` is a second copy of each default version. The [Version pins check](/supply-chain/version-pins-check--01a1837fdfc3.md) makes sure that it agrees with `devcontainer-feature.json`.

## Failure-mode tests

For some features, the script checks that each failure occurs with the expected message:

* A missing `-e` names the variable, for example `_cue_checksum is defined`.
* An empty mandatory option stops in the shell with `resolved empty`.
* A version with no pinned checksum stops with `No SHA256 is pinned`.
* A malformed checksum or version fails the shape assert.

On 2026-10-28, eight features have failure-mode tests: `cuelang`, `maven`, `gradle`, `grype`, `kaniko`, `envbuilder`, `sshd` and `python`. A failure-mode test runs only when the template installs that feature.

## Related

* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md)
* [Role contract](/architecture/role-contract--01a1837fddd1.md)
* [Test templates](/architecture/test-templates--01a1837fde68.md)
* [Test one template locally](/operations/test-one-template-locally--01a1837fe195.md)
* [Architecture overview](/architecture/architecture-overview--01a1837af69f.md)
