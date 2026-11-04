---
id: "01a1837f-e0ed-76d8-99f1-b4903a96928e"
title: "CODEOWNERS"
type: "component"
tags:
  - "supply-chain"
  - "codeowners"
created: "2026-10-28T12:12:38-05:00"
timestamp: "2026-10-28T12:20:27-05:00"
description: ".github/CODEOWNERS assigns @ryancraig as the reviewer of every path but gates no merge, because the organization has one member."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:27-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/.github/CODEOWNERS"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/SETUP-ENVIRONMENTS.md"
    title: "SETUP-ENVIRONMENTS.md step 4"
---

# CODEOWNERS

`.github/CODEOWNERS` names `@ryancraig` as the owner of every path. It assigns the reviewer and marks which paths are trust decisions. It does not gate a merge.

## Why it does not gate

The `infrashift` organization has one member. GitHub does not let a person approve their own pull request. With "Require review from Code Owners" on, each pull request would need an admin bypass. A protection that each merge bypasses is worse than no protection, because it looks enforced. The `main` ruleset sets `require_code_owner_review: false` and 0 required approvals.

## Path groups in the file

| Group | Paths |
|---|---|
| Trust decisions | `.github/pdp/`, `tools.lock`, `scripts/install-tools.sh` |
| Pipeline engines | `.github/workflows/`, `scripts/` |
| What ships in a feature | `src/`, `src/bootstrap/` |
| Security posture | `.github/CODEOWNERS`, `.gitleaks.toml`, `.gitignore`, `SETUP-ENVIRONMENTS.md` |
| Documentation | `docs/`, `README.md` |
| Project knowledge and agent instructions | `.okfw/`, `CLAUDE.md`, `AGENTS.md`, `.mcp.json`, `.claude/` |

## When a second maintainer joins

`SETUP-ENVIRONMENTS.md` step 4 gives the change. Do all of these steps in one change:

1. Create the teams.
2. Put the teams in `CODEOWNERS`.
3. Turn on "Require review from Code Owners".
4. Turn on "Prevent self-review" on `Release-Actor`.

## Related

* [CODEOWNERS and the human gate assume a multi-person org](/issues/codeowners-and-the-human-gate-assume-a-multi-person-org--01a183826510.md)
* [Signing actors and keys](/supply-chain/signing-actors-and-keys--01a1837fdf43.md)
* [Set up the GitHub environments and signing keys](/operations/set-up-the-github-environments-and-signing-keys--01a1837fe20a.md)
* [Supply chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
