# Infrashift Dev Container Features

A collection of [Dev Container Features](https://containers.dev/implementors/features/) for trusted, RPM-based development containers (Fedora 43 and Red Hat UBI).

Each feature is metadata plus an Ansible role. A single shared runner — provided by the `bootstrap` feature — turns that into an installation, so features contain no imperative shell beyond a five-line wrapper. See [Architecture](https://infrashift.github.io/trusted-devcontainer-features/reference/architecture/).

## Features

| Feature | Description | Usage |
|---------|-------------|-------|
| `bootstrap` | Provisions the pinned Ansible environment every other feature installs through. Pulled in automatically via `dependsOn`. | `ghcr.io/infrashift/trusted-devcontainer-features/bootstrap:latest` |
| `ansible-core` | Installs ansible-core via UV tool | `ghcr.io/infrashift/trusted-devcontainer-features/ansible-core:latest` |
| `bun` | Installs the Bun JavaScript runtime | `ghcr.io/infrashift/trusted-devcontainer-features/bun:latest` |
| `claude-code` | Installs Claude Code (Anthropic's AI coding assistant CLI) | `ghcr.io/infrashift/trusted-devcontainer-features/claude-code:latest` |
| `cuelang` | Installs CUElang | `ghcr.io/infrashift/trusted-devcontainer-features/cuelang:latest` |
| `dotnet` | Installs the .NET SDK | `ghcr.io/infrashift/trusted-devcontainer-features/dotnet:latest` |
| `egress-filter` | Installs squid proxy and iptables for egress filtering | `ghcr.io/infrashift/trusted-devcontainer-features/egress-filter:latest` |
| `git` | Installs Git | `ghcr.io/infrashift/trusted-devcontainer-features/git:latest` |
| `git-lfs` | Installs Git LFS | `ghcr.io/infrashift/trusted-devcontainer-features/git-lfs:latest` |
| `golang` | Installs the Go programming language | `ghcr.io/infrashift/trusted-devcontainer-features/golang:latest` |
| `grype` | Installs the Grype vulnerability scanner | `ghcr.io/infrashift/trusted-devcontainer-features/grype:latest` |
| `jq` | Installs the jq JSON processor | `ghcr.io/infrashift/trusted-devcontainer-features/jq:latest` |
| `nodejs` | Installs Node.js | `ghcr.io/infrashift/trusted-devcontainer-features/nodejs:latest` |
| `npm` | Updates npm to a specific version | `ghcr.io/infrashift/trusted-devcontainer-features/npm:latest` |
| `openai-codex` | Installs OpenAI Codex CLI | `ghcr.io/infrashift/trusted-devcontainer-features/openai-codex:latest` |
| `openjdk` | Installs OpenJDK | `ghcr.io/infrashift/trusted-devcontainer-features/openjdk:latest` |
| `pnpm` | Installs the pnpm package manager | `ghcr.io/infrashift/trusted-devcontainer-features/pnpm:latest` |
| `python` | Installs a specific Python version via UV | `ghcr.io/infrashift/trusted-devcontainer-features/python:latest` |
| `sudo` | Installs sudo and configures passwordless sudo for the container user | `ghcr.io/infrashift/trusted-devcontainer-features/sudo:latest` |
| `syft` | Installs the Syft SBOM generator | `ghcr.io/infrashift/trusted-devcontainer-features/syft:latest` |
| `uv-ruff` | Installs UV and Ruff Python tools | `ghcr.io/infrashift/trusted-devcontainer-features/uv-ruff:latest` |
| `yq` | Installs the yq YAML processor | `ghcr.io/infrashift/trusted-devcontainer-features/yq:latest` |

## Usage

Add features to your `devcontainer.json`:

You do not need to list `bootstrap` — every feature declares `dependsOn` it, so the
runtime installs it automatically.

```jsonc
{
    "features": {
        "ghcr.io/infrashift/trusted-devcontainer-features/git:latest": {},
        "ghcr.io/infrashift/trusted-devcontainer-features/nodejs:latest": {},
        "ghcr.io/infrashift/trusted-devcontainer-features/python:latest": {
            "target_version": "3.12"
        }
    }
}
```

## Development

### Testing

Features are tested by building the six templates under `test-templates/` and
exercising them, which is what CI does. There is no per-feature `test/` tree.

```bash
# Verify every role satisfies the parameter contract (seconds, no containers)
make check-contract

# Build one template and run its smoke tests
make test-template TEMPLATE=python

# Idempotency and failure-mode tests against that running container
make test-contract TEMPLATE=python

# Everything: contract check, then all six templates
make test

# Remove test containers and the copied feature trees
make clean
```

`make check-contract` enforces the role contract described in
[ADR-012](docs/src/content/docs/decisions/adr-012-feature-role-contract.md):
role `defaults/main.yml` stays empty, both assert brackets are present, every
option has a default, mandatory options are guarded in `install.sh`, and every
download is checksum-verified. It also cross-checks, in both directions, that
each `-e` in `install.sh` matches the role's parameter assertions — which is what
catches an option added without an assertion, or a variable renamed on one side.

`make test-contract` covers what smoke tests cannot: that re-running a role
reports `changed=0`, and that a missing parameter, an empty mandatory option, an
unpinned version and a malformed digest each fail by name before any work
happens.

## License

MIT
