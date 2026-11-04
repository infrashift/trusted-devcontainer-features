---
id: "01a1837f-e074-7de5-aa66-2dedb76fee43"
title: "Secret scanning"
type: "component"
tags:
  - "supply-chain"
  - "gitleaks"
  - "secrets"
created: "2026-10-28T12:12:38-05:00"
timestamp: "2026-10-28T12:20:27-05:00"
description: "gitleaks scans the full history with .gitleaks.toml; three guards make sure that an empty config cannot pass as a clean scan."
generated:
  by: "claude-code/opus-5-5"
  at: "2026-10-28T12:20:27-05:00"
status: "draft"
resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/.gitleaks.toml"
sources:
  - resource: "https://github.com/infrashift/trusted-devcontainer-features/blob/main/.github/workflows/pr-gate.yml"
    title: "pr-gate.yml"
---

# Secret scanning

`gitleaks` scans the full Git history with the config `.gitleaks.toml`. `scripts/repo-gate.sh` runs it with `--exit-code 0`, and the [PDP](/supply-chain/policy-decision-point-pdp--01a1837fdf26.md) decides on the findings. An empty config has zero rules and exits 0, so three guards stop it.

## The three guards

1. `.gitleaks.toml` sets `[extend] useDefault = true`.
2. The `repo-gate` job fails when `.gitleaks.toml` has fewer than 64 bytes or no `useDefault = true`. This occurs before `gitleaks` runs.
3. The PDP denies with `GITLEAKS_CONFIG_EMPTY` and `GITLEAKS_DEFAULTS_DISABLED`. It reads the measured byte count.

## Rules added to the defaults

| Rule id | Finds |
|---|---|
| `cosign-sigstore-private-key` | A cosign or Sigstore private key block |
| `pem-private-key-block` | Any PEM private key block |
| `jwt-token` | A JWT, for example an OIDC token |
| `github-pat` | A GitHub token (`ghp_`, `gho_`, `ghu_`, `ghs_`, `ghr_`, `github_pat_`) |
| `anthropic-api-key` | `sk-ant-...` |
| `openai-api-key` | `sk-...` and `sk-proj-...` |

The `claude-code` and `openai-codex` features make the AI provider key rules necessary. An example in a `NOTES.md` or a docs page could contain a real key.

## Allowlist

* Paths: `.github/pdp/public-keys/*.pub`, `docs/dist/`, `docs/node_modules/`, `docs/.astro/`, `.github/pdp/policies_test.rego`.
* Regexes: `sha256:` followed by 64 zeros, and `sha256:<fill>`.

`.gitignore` also excludes `*.key`, `*.pem`, `*.env` and `*.secret`.

## Full history

The `repo-gate` job checks out with `fetch-depth: 0`. A key that was committed and then removed is still a leaked key. A shallow local clone scans fewer commits.

## Related

* [Policy decision point (PDP)](/supply-chain/policy-decision-point-pdp--01a1837fdf26.md)
* [PR Gate workflow](/supply-chain/pr-gate-workflow--01a1837fdeb7.md)
* [Pinned CI tools](/supply-chain/pinned-ci-tools--01a1837fe09c.md)
* [Supply chain overview](/supply-chain/supply-chain-overview--01a1837af6e6.md)
