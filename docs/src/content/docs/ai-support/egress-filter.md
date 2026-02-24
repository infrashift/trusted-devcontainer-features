---
title: Egress Filtering for AI Agents
description: Controlling AI agent network access with domain-based egress filtering.
---

## Overview

When running AI coding assistants inside DevContainers, you may want to restrict their network access to only the domains they need. The [Egress Filter](/trusted-devcontainer-features/features/egress-filter/) feature provides domain-based allowlisting using Squid proxy and iptables.

## Why Filter AI Agent Traffic?

AI coding assistants can make network requests — fetching documentation, downloading packages, or calling external APIs. In regulated or security-sensitive environments, you may need to:

- **Limit API access**: Ensure AI agents only communicate with their provider's API endpoints
- **Prevent data exfiltration**: Block unauthorized outbound connections
- **Audit network activity**: Log all outbound requests through the proxy
- **Comply with policies**: Meet organizational security requirements for AI tool usage

## Configuration for Claude Code

To allow Claude Code to function while filtering all other traffic:

```jsonc
{
    "features": {
        "ghcr.io/infrashift/trusted-devcontainer-features/bun:latest": {},
        "ghcr.io/infrashift/trusted-devcontainer-features/claude-code:latest": {},
        "ghcr.io/infrashift/trusted-devcontainer-features/egress-filter:latest": {
            "allowed_domains": "api.anthropic.com,.anthropic.com,.github.com,.githubusercontent.com"
        }
    },
    "containerEnv": {
        "ANTHROPIC_API_KEY": "${localEnv:ANTHROPIC_API_KEY}"
    }
}
```

## Configuration for OpenAI Codex

```jsonc
{
    "features": {
        "ghcr.io/infrashift/trusted-devcontainer-features/bun:latest": {},
        "ghcr.io/infrashift/trusted-devcontainer-features/openai-codex:latest": {},
        "ghcr.io/infrashift/trusted-devcontainer-features/egress-filter:latest": {
            "allowed_domains": "api.openai.com,.openai.com,.github.com,.githubusercontent.com"
        }
    },
    "containerEnv": {
        "OPENAI_API_KEY": "${localEnv:OPENAI_API_KEY}"
    }
}
```

## Configuration for Both

```jsonc
{
    "features": {
        "ghcr.io/infrashift/trusted-devcontainer-features/bun:latest": {},
        "ghcr.io/infrashift/trusted-devcontainer-features/claude-code:latest": {},
        "ghcr.io/infrashift/trusted-devcontainer-features/openai-codex:latest": {},
        "ghcr.io/infrashift/trusted-devcontainer-features/egress-filter:latest": {
            "allowed_domains": "api.anthropic.com,.anthropic.com,api.openai.com,.openai.com,.github.com,.githubusercontent.com"
        }
    }
}
```

## How It Works

1. **Squid proxy** is installed and configured with an allowlist of domains
2. **iptables rules** redirect all outbound HTTP (port 80) and HTTPS (port 443) traffic through the local Squid proxy
3. **Environment variables** (`http_proxy`, `https_proxy`) are set so that tools automatically route through the proxy
4. A **startup script** (`egress-filter-start.sh`) runs as `postStartCommand` to apply iptables rules each time the container starts
5. Requests to **non-allowed domains** are blocked by Squid and return a deny page

## Adding Package Registry Access

If you need to install packages during development, add the relevant registries:

```jsonc
{
    "allowed_domains": "api.anthropic.com,.anthropic.com,.npmjs.org,.npmjs.com,registry.npmjs.org,.github.com,.githubusercontent.com,pypi.org,files.pythonhosted.org"
}
```

## Capabilities Required

The egress filter requires Linux capabilities `NET_ADMIN` and `NET_RAW` for iptables manipulation. These are automatically declared in the feature's `devcontainer-feature.json` via `capAdd`.

## Troubleshooting

### Proxy not intercepting traffic
Ensure the container was started with `NET_ADMIN` and `NET_RAW` capabilities. Check that `egress-filter-start.sh` ran successfully:

```bash
# Check iptables rules
sudo iptables -t nat -L -n

# Check Squid status
sudo systemctl status squid || sudo squid -k check
```

### Requests being blocked unexpectedly
Check the Squid access log to see what domains are being requested:

```bash
sudo tail -f /var/log/squid/access.log
```

Add any missing domains to the `allowed_domains` option with a `.` prefix for subdomain matching.
