---
title: "ADR-012: Feature Role Contract"
description: The shared runner, the userland and privileged lanes, and the idempotency rules every feature role must satisfy.
---

**Status:** Accepted

## Context

[ADR-002](/trusted-devcontainer-features/decisions/adr-002-ansible-bootstrapper/) established that `install.sh` is a thin wrapper and real logic lives in Ansible. In practice each of the 21 features carried its own ~60-line copy of that "thin" wrapper — 21 distinct checksums, no shared library — plus a near-identical `hosts.yml` and the same boilerplate task bracket. Fixes had to be applied 21 times, and several features had already drifted.

Privilege handling had drifted too. Features ran `ansible-playbook` as root and then de-escalated per task with `become_user` + `become_method: su`, which meant root-owned files appearing in the user's home and trailing `chown -R` repair steps, plus `UV_CACHE_DIR` and `ANSIBLE_LOCAL_TMP` redirections to stop root-owned caches accumulating there. `su` also does not exist on `fedora43-minimal`.

## Decision

### One shared runner

`/opt/bootstrap/run-feature.sh`, provided by the `bootstrap` feature, is the single entrypoint:

```
run-feature.sh --role <dir> [--privileged] [-e key=value]...
```

A feature's `install.sh` becomes a wrapper with no logic in it:

```bash
#!/usr/bin/env bash
set -euo pipefail
exec /opt/bootstrap/run-feature.sh \
    --role ansible-role-feature \
    -e "_cue_version=${TARGET_VERSION}"
```

Per-feature `hosts.yml` and `activate-feature.yml` are deleted. A single generic `site.yml` applies the role named by `feature_role`. Extra vars are passed with their role-internal underscore names, overriding `defaults/main.yml` directly, which removes the bare-to-underscore mapping layer.

### Two lanes

**Userland (default).** The runner drops from root to the target user before Ansible starts. Every file is created correctly owned, so roles need no `become`, no `owner`/`group`, and no `chown` repair.

De-escalation uses **`setpriv`**, not `su` or `runuser`. Both of those authenticate through PAM, which fails during a container build with `failed to establish user credentials: Permission denied` because the build lacks the required capabilities. `setpriv` performs a plain setuid/setgid with no PAM involvement.

**Privileged (`--privileged`).** Stays root, for features that genuinely mutate system state — currently `git` and `git-lfs`, both of which install system packages.

### Ansible scratch state

The runner sets `ANSIBLE_HOME`, `ANSIBLE_REMOTE_TMP`, and `ANSIBLE_LOCAL_TEMP` under `/tmp`. All three are required: `ANSIBLE_HOME` alone still leaves `remote_tmp` defaulting to `~/.ansible/tmp`. Since the base image sets `ENV HOME=/home/<user>`, any root-run Ansible invocation would otherwise create a root-owned `~/.ansible` that the user can no longer write to.

### Parameter contract

`devcontainer-feature.json` is the **single source of truth for every option default**. Role `defaults/main.yml` is empty in every role.

The reason is Ansible's precedence order. `install.sh` passes each option as an extra-var, and extra-vars outrank role defaults. A value in `defaults/main.yml` that mirrors an option is therefore already unreachable — it can only take effect when the wiring above it is broken, turning a missing option into a silently wrong value instead of an error. Before this change, 18 of 21 roles duplicated their version string, `golang` kept an unreachable SHA256, and `SKELETON` shipped `_color: "blue"` against an option default of `"green"`.

The one-way chain, enforced at each link:

```
devcontainer-feature.json  options.<id>.default
        |  materialized by the devcontainer CLI into an env var
        v
install.sh                 ${TARGET_VERSION:?...}      <- fails here if empty
        |  forwarded as an Ansible extra-var
        v
run-feature.sh             -e "_cue_version=..."
        |  extra-vars outrank role defaults
        v
tasks/main.yml             PARAMETER BRACKET           <- fails here if absent
```

Each role's `tasks/main.yml` carries two asserts directly below the variant (bootstrap) bracket:

1. **Runner contract** — `_target_username`, `_target_user_home`, `_target_arch` are present and sane. Catches a role run outside `run-feature.sh`, or against an older `bootstrap`.
2. **Required parameters** — every value `install.sh` is supposed to pass. The failure message names the variable and the option it comes from.

Three parameter classes:

| Class | Example | Assertion |
| --- | --- | --- |
| Mandatory | `target_version` | `${VAR:?}` in `install.sh`, then `is defined and \| length > 0` |
| Pass-through | `target_checksum` | `is defined` only — empty legitimately means "use the pinned map or upstream checksums file" |
| Enumerated | `color_choice` | `is defined` and membership in the allowed set |

`${VAR:?}` in the shell is not redundant with the role assert: Ansible cannot distinguish an unset variable from one passed as an empty string, and the shell fails earlier and more cheaply.

Booleans arrive as the **string** `"true"`/`"false"` — `-e key=value` is always parsed as a string. Assert membership and apply `| bool` at the point of use.

Derived values (tarball names, download URLs, resolved checksums) and role constants (pinned checksum maps, platform strings) live in `vars/main.yml`. They are not caller-settable, and moving them there is what lets `defaults/main.yml` be empty as a checkable invariant.

Corollary: `| default(...)` must never mask a runner-injected variable. `_target_arch | default('amd64')` looks defensive but converts a broken runner into an amd64 binary installed on arm64 — which then passes its own amd64 checksum.

### Shape, not just presence

Asserting a parameter is non-empty catches a missing value but not a wrong-shaped one. `target_version: "1.26"` or a checksum truncated on paste both pass a presence check and then fail much later — as a 404 on a URL built from the value, or as an opaque `get_url` digest mismatch. The parameter bracket therefore also asserts form:

| Class | Rule |
| --- | --- |
| Versions | a regex matching that upstream's real format — `X.Y.Z` for most, `X.Y` for `python`, `X.Y.Z+B` for `openjdk`, `latest\|X.Y.Z` for the two npm dist-tag features |
| Checksums | when non-empty, 64 hex characters (SHA256); 128 for `dotnet`, the lone SHA512 |
| Enumerations | membership in the allowed set |

Every shape condition states the expected form in `fail_msg`. An assert that fails without saying what it wanted only relocates the guesswork.

### Verify the version, not the binary

The final assert in each role must confirm the **requested** version installed, not merely that something runs. An assert matching the tool's own name passes for every version, so it cannot catch the failure it exists to catch — 13 of 21 roles were in that state.

Match each upstream's real output, captured rather than assumed. The formats do not generalise: `go version go1.26.0` has no space, `jq --version` prints `jq-1.7.1`, `yq` and `cue` are `v`-prefixed, `java -version` writes to **stderr**, and `uv python find` returns an interpreter *path* (`…/cpython-3.12-linux-…`), not a version.

Bare substring tests are unsafe wherever one advertised version is a prefix of another: `jq` offers both `1.7` and `1.7.1`, so `'1.7' in stdout` accepts a 1.7.1 binary for a 1.7 request. Anchor on the separator instead.

Two roles cannot assert equality at all: `claude-code` and `openai-codex` take the npm dist-tag `latest`, and their binaries only ever report a resolved semver. They assert semver-shaped output always, and exact match only when pinned.

Package-manager installs (`git`, `git-lfs`) have no requested version, so a name match is the strongest check available and is correct there.

### Enforcement

The contract holds only while every role follows it, and a role copied from `SKELETON` can drift silently. `scripts/check-role-contract.sh` is what notices. It runs as `make check-contract`, as the `contract` CI job on every PR, and — because a violating feature must not publish — as a `needs:` gate on the release workflow.

It checks that `defaults/main.yml` declares nothing; that both bracket asserts are present; that every option has a `default`; that mandatory options carry a `${VAR:?}` guard while `*_checksum` options use `${VAR:-}`; that no `| default(…)` masks a runner-injected variable; and that every `get_url` passes a `checksum:` — exempting the three tasks that fetch a checksums *file*, which cannot verify themselves.

Its most valuable check is bidirectional: every `-e` in `install.sh` must appear in that role's parameter bracket, **and** every asserted variable must be passed. That catches an option added without an assert, and a variable renamed on one side only.

The script is pure `bash` + `sed`/`grep`/`awk` by necessity: `devcontainer-feature.json` is JSONC (it opens with `//` comments) so `jq` and `yq` both refuse it, and the base image ships no `python3`.

### Idempotency contract

Re-running a feature must report `changed=0`:

- Probe the installed version first and gate install work on a needs-install fact.
- Download with `get_url` **and a `checksum:` argument**. Never download unverified ([ADR-006](/trusted-devcontainer-features/decisions/adr-006-checksum-verification/)).
- Guard `unarchive` behind that fact, or use `creates:`.
- Never use `command` without `creates:` or an accurate `changed_when:`.
- Probes use `failed_when: false` + `changed_when: false`, not `ignore_errors: true`, which reports a red `ignored` task for expected conditions.
- Install to `~/.local/share/<tool>` with a symlink into `~/.local/bin`.
- Derive architecture from `_target_arch` (`amd64`/`arm64`). Never hardcode.

`.devcontainer/SKELETON-feature/` is the canonical template for all of the above.

## Consequences

- **Positive**: The wrapper shrinks from ~60 lines to ~5, and a runner fix applies everywhere at once.
- **Positive**: No root-owned files in the user's home, so the chown/cache-redirect workarounds are deleted rather than maintained.
- **Positive**: `changed=0` on re-run is asserted for every role by `test-templates/shared/contract-tests.sh`, alongside negative tests for each failure mode — a missing `-e`, an empty mandatory option, an unpinned version, and a bad digest.
- **Positive**: Checksum verification becomes structural rather than optional.
- **Positive**: One place to change a value. A missing or empty option fails by name, before any download, instead of surfacing as a 404 on a malformed URL.
- **Positive**: `defaults/main.yml` being empty is a greppable invariant, so a reintroduced default is visible in review.
- **Positive**: `--privileged` makes the small set of features that touch system state explicit and auditable.
- **Negative**: Features depend on the runner's interface; changing it is a breaking change across all of them.
- **Negative**: Pinned checksums must be updated when bumping a tool version. Installing a non-default version now requires supplying `target_checksum`.
- **Negative**: One indirection between `install.sh` and the role, which is less obvious when debugging a single feature.
- **Negative**: A role can no longer be run standalone with `ansible-playbook` and no extra-vars; it has nothing to fall back on. That is the intent, but it makes ad-hoc invocation more verbose.
- **Negative**: Adding an option now means touching three files — `devcontainer-feature.json`, `install.sh`, and the parameter bracket — rather than silently relying on a role default.

## Alternatives Considered

- **Shared bash library sourced by each feature**: Still copies the library into every feature, so drift returns.
- **Keep per-feature `activate-feature.yml`**: Retains a file per feature whose only job is renaming variables.
- **Run everything as root and chown afterwards**: The status quo. Every role must remember the repair step, and forgetting produces a subtly broken container.
