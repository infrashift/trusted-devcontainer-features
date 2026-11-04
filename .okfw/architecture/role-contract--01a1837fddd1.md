---
id: "01a1837f-ddd1-7ab8-9238-7c4986147e10"
title: "Role contract"
type: "component"
tags:
  - "architecture"
  - "role-contract"
  - "adr-012"
created: "2026-10-28T12:12:37-05:00"
timestamp: "2026-10-28T12:20:26-05:00"
description: "The ADR-012 rules that make a missing or bad option fail by name; make check-contract enforces the static rules on each role."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:26-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/docs/src/content/docs/decisions/adr-012-feature-role-contract.md"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/scripts/check-role-contract.sh"
    title: "scripts/check-role-contract.sh"
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/.devcontainer/SKELETON-feature/install.sh"
    title: "SKELETON-feature install.sh"
---

# Role contract

The role contract is the set of rules in ADR-012 that each role and each `install.sh` obey. Its purpose: a missing or incorrect option fails early and by name. `scripts/check-role-contract.sh` enforces the static part. `make check-contract`, the `repo-gate` job and the `contract` job of the release run it.

## The chain of one option

```
devcontainer-feature.json  options.<id>.default   the only default
install.sh                 ${TARGET_VERSION:?}    fails here when empty
run-feature.sh             -e "_<tool>_version=…" extra-vars outrank role defaults
tasks/main.yml             parameter bracket      fails here when absent
```

## Rules

1. `devcontainer-feature.json` holds the default of each option. `defaults/main.yml` of the role declares nothing.
2. `vars/main.yml` holds derived values and constants, for example pinned checksum maps and URLs.
3. `tasks/main.yml` starts with the variant assert, then the runner-contract assert (`_target_username`, `_target_user_home`, `_target_arch`), then the parameter assert.
4. The parameter assert checks shape, not only presence: a version regex, 64 hex characters for SHA256 (128 for SHA512), or membership in a set.
5. Booleans arrive as the strings `"true"` and `"false"`. Apply `| bool` where you use them.
6. `| default(...)` must not mask a runner-injected variable.
7. Each `get_url` has a `checksum:` argument (ADR-006).
8. The last task verifies the requested version, not only that the tool runs.
9. A second run reports `changed=0`.

## What `check-role-contract.sh` checks

It checks each role in `src/` and `.devcontainer/SKELETON-feature`:

* `defaults/main.yml` declares no variable.
* Both bracket asserts are present.
* Each `-e` in `install.sh` is in the parameter assert, and each asserted variable is in `install.sh`.
* Each option has a `default`.
* Each mandatory option has a `${VAR:?}` guard. Each `*checksum*` option uses `${VAR:-}`.
* No `| default(...)` masks `_target_arch`, `_target_user_home` or `_target_username`.
* Each `get_url` has `checksum:`. A task with "checksums file" or "signature bundle" in its name is exempt. The check tests the name of the `get_url` task itself.

A role verifies a signature bundle against a pinned key, so a changed bundle fails that check. Thus the bundle download needs no checksum. A role that downloads a bundle must verify it. [Feature: okfw](/features/feature-okfw--01a1a8536440.md) is the only role that downloads a bundle.

Before 2026-11-04, the exemption tested the name of the next task, not the name of the `get_url` task. `grype` passed only because its next task also had "checksums file" in its name.

The script uses only `bash`, `sed`, `grep` and `awk`. `jq` cannot read the JSONC files, and the maintainer base image has no `python3`.

[Contract tests](/architecture/contract-tests--01a1837fde81.md) check rules 8 and 9 at run time.

## Related

* [ADR-012: Feature role contract](/decisions/adr-012-feature-role-contract--01a183801367.md)
* [ADR-006: Checksum verification](/decisions/adr-006-checksum-verification--01a183801256.md)
* [Feature install pipeline](/architecture/feature-install-pipeline--01a1837fdd88.md)
* [Contract tests](/architecture/contract-tests--01a1837fde81.md)
* [Static checks](/supply-chain/static-checks--01a1837fe0c4.md)
* [Add a new feature](/operations/add-a-new-feature--01a1837fe116.md)
* [Decisions overview](/decisions/decisions-overview--01a1837af6ce.md) — ADR-006 and ADR-012.
* [Architecture overview](/architecture/architecture-overview--01a1837af69f.md)
