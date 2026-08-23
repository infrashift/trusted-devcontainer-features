---
title: "ADR-010: Fedora 43 Target"
description: Decision to target Fedora 43 alongside UBI, with the container variant detected once at bootstrap time.
---

**Status:** Accepted — supersedes [ADR-001](/trusted-devcontainer-features/decisions/adr-001-ubi-image-support/)

## Context

[ADR-001](/trusted-devcontainer-features/decisions/adr-001-ubi-image-support/) targeted UBI 9 exclusively, on the reasoning that multi-distro support would mean "OS detection, conditional package commands, and a doubled test matrix." The trusted templates have since moved to `fedora43-minimal`, so the features must work there.

### The compatibility guard was never actually working

Every feature shipped a `hosts.yml` that hardcoded `localhost` into the `ubi9` group:

```yaml
ubi9:
  hosts:
    localhost:
      ansible_connection: local
  vars:
    securedevcontainer_variant: "ubi9"
```

`securedevcontainer_variant` was therefore **always** `"ubi9"`, whatever the image underneath. The assert at the top of every role compared `"ubi9"` against `["ubi9", "ubi10"]` and passed unconditionally. It never inspected the running system, so it would have reported success on Fedora, Debian, or anything else.

The migration exposed this because it was the first time the value was expected to be anything other than `ubi9`.

### What actually differs on Fedora

Less than ADR-001 feared, because features install into the user's home rather than through the system package manager. The real differences:

- `fedora43-minimal` ships no `tar`, `gzip`, `python3`, `su`, or `runuser`. These are supplied by the template's base layer, not by features.
- Privilege de-escalation must use `setpriv`, not `su`/`runuser` — the latter go through PAM, which lacks the capabilities it needs during a container build.
- The `sudo` feature's `yum_repository` block pointed at `cdn-ubi.redhat.com`, which is meaningless on Fedora. Fedora's repositories are already configured, so the block is simply removed.

## Decision

Detect the variant **once**, in the `bootstrap` feature's `install.sh`, from `/etc/os-release`, and publish it as a group variable in the single generated `/opt/bootstrap/inventory.yml`:

```bash
. /etc/os-release
OS_MAJOR="${VERSION_ID%%.*}"
case "${ID}" in
    rhel)   VARIANT="ubi${OS_MAJOR}" ;;   # UBI images report ID=rhel
    fedora) VARIANT="fedora${OS_MAJOR}" ;;
    *)      VARIANT="${ID}${OS_MAJOR}" ;;
esac
```

Per-feature `hosts.yml` files are deleted. Each role's `vars/main.yml` lists the variants it has actually been tested against, and the opening assert becomes a real check.

The UBI mapping is retained deliberately: UBI images report `ID=rhel`, so mapping `rhel` → `ubi<major>` keeps existing `ubi9`/`ubi10` compatibility lists accurate.

## Consequences

- **Positive**: The compatibility assert now does what it always claimed to do.
- **Positive**: Detection lives in one place instead of 21 near-identical inventory files.
- **Positive**: Adding a distro means extending one `case` and the compatibility lists, not editing every feature.
- **Positive**: A feature run on an untested variant now fails loudly instead of silently proceeding.
- **Negative**: Compatibility lists must be honest. Adding `fedora43` to a role asserts it was tested there; the list is now load-bearing.
- **Negative**: The test matrix does widen, exactly as ADR-001 predicted — mitigated by userland installs, which are largely distro-independent.

## Alternatives Considered

- **Keep UBI-only and fork for Fedora**: Two feature sets to maintain and publish.
- **`gather_facts: true` and use `ansible_distribution`**: Costs a fact-gathering round per feature and needs a working interpreter before the variant is known. Detecting once at bootstrap is cheaper and available earlier.
- **Drop the compatibility assert**: Tempting, given it never worked — but it is the only guard against a role assuming a package manager or filesystem layout that is not there.
