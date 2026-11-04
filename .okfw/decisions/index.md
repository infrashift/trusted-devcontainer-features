# decisions

<!-- okfw:generated — maintained by okfw; edits here are overwritten -->

## Concepts

* [ADR-001: UBI 9 base image](adr-001-ubi-9-base-image--01a183801183.md) - Superseded by ADR-010: the features targeted Red Hat UBI 9 only, with dnf and the UBI repositories.
* [ADR-002: Ansible as the feature installer](adr-002-ansible-as-the-feature-installer--01a1838011ad.md) - Accepted: an Ansible role does the installation of each feature, and install.sh is only a thin wrapper.
* [ADR-003: Non-root vscode user](adr-003-non-root-vscode-user--01a1838011d7.md) - Superseded by ADR-011: the features installed for a vscode user with UID and GID 1000.
* [ADR-004: uv as the Ansible runner](adr-004-uv-as-the-ansible-runner--01a183801200.md) - Superseded by ADR-008: each install.sh ran Ansible with uv run --with ansible-core in a temporary environment.
* [ADR-005: Bun as the package manager](adr-005-bun-as-the-package-manager--01a18380122a.md) - Accepted: Bun installs the claude-code and openai-codex CLIs, and Bun manages the documentation site.
* [ADR-006: Checksum verification](adr-006-checksum-verification--01a183801256.md) - Accepted and amended by ADR-012: every download is verified against a SHA256 or SHA512 checksum, and verification is mandatory.
* [ADR-007: installsAfter dependency model](adr-007-installsafter-dependency-model--01a183801281.md) - Superseded by ADR-009: features declared their dependencies only with installsAfter, which orders features but does not install them.
* [ADR-008: Pinned bootstrap environment](adr-008-pinned-bootstrap-environment--01a1838012ac.md) - Accepted: the bootstrap feature installs pinned, checksum-verified uv, CPython and ansible-core in a root-owned /opt/bootstrap. Supersedes ADR-004.
* [ADR-009: Mandatory dependencies with dependsOn](adr-009-mandatory-dependencies-with-dependson--01a1838012db.md) - Accepted: every feature declares bootstrap in dependsOn, so the runtime installs it; installsAfter stays for order only. Supersedes ADR-007.
* [ADR-010: Fedora 43 target](adr-010-fedora-43-target--01a183801309.md) - Accepted: bootstrap detects the OS variant once from /etc/os-release, and each role asserts a tested variant. Supersedes ADR-001.
* [ADR-011: dev user alignment](adr-011-dev-user-alignment--01a183801339.md) - Accepted: the dev user is dev with UID 1001, and the runner takes the user and home from the devcontainer CLI. Supersedes ADR-003.
* [ADR-012: Feature role contract](adr-012-feature-role-contract--01a183801367.md) - Accepted: one shared runner, a userland and a privileged lane, empty role defaults, parameter asserts and idempotent roles, enforced by make check-contract.
* [Decisions overview](decisions-overview--01a1837af6ce.md) - One pointer concept for each architecture decision record (ADR) in the documentation site.

