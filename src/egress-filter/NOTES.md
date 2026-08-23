# Egress Filter Feature

Domain-based egress filtering for Red Hat UBI DevContainers using Squid proxy and iptables.

## How It Works

This feature uses a two-layer approach to restrict outbound network access:

1. **Squid proxy** provides domain-level filtering, including HTTPS via CONNECT/SNI and wildcard domain support through a configurable domain whitelist.
2. **iptables rules** prevent any process from bypassing the proxy. Even applications that ignore `http_proxy`/`https_proxy` environment variables cannot reach unauthorized destinations.

## Container Requirements

This feature requires the following Linux capabilities (declared automatically via `capAdd`):

- `NET_ADMIN` - Required for iptables rule management
- `NET_RAW` - Required for raw socket operations

## Configuration Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `allowed_domains` | string | `example.com` | Comma-separated list of allowed domains |
| `squid_port` | string | `3128` | Localhost port for Squid proxy |

### Domain Syntax

- `example.com` - Matches exactly `example.com`
- `.example.com` - Matches `example.com` and all subdomains (e.g., `api.example.com`, `www.example.com`)

## Example devcontainer.json Usage

```json
{
    "features": {
        "./egress-filter-feature": {
            "allowed_domains": ".github.com,.githubusercontent.com,.npmjs.org,.registry.npmjs.org",
            "squid_port": "3128"
        }
    }
}
```

## Environment Variables Set

The following environment variables are automatically set via `containerEnv`:

| Variable | Value |
|----------|-------|
| `http_proxy` | `http://localhost:3128` |
| `https_proxy` | `http://localhost:3128` |
| `HTTP_PROXY` | `http://localhost:3128` |
| `HTTPS_PROXY` | `http://localhost:3128` |
| `no_proxy` | `localhost,127.0.0.1` |
| `NO_PROXY` | `localhost,127.0.0.1` |

## Files Installed

| File | Purpose |
|------|---------|
| `/etc/squid/squid.conf` | Squid proxy configuration |
| `/etc/squid/allowed_domains.txt` | Domain whitelist (one domain per line) |
| `/usr/local/bin/egress-filter-start.sh` | Startup script (runs via `postStartCommand`) |

## Troubleshooting

### Check Squid Status

```bash
squid -k check
```

### View Squid Access Logs

```bash
cat /var/log/squid/access.log
```

### View iptables Egress Rules

```bash
sudo iptables -L EGRESS_FILTER -n -v
```

### Test Filtering

```bash
# Should succeed (if domain is whitelisted)
curl https://github.com

# Should fail with proxy denial (non-whitelisted domain)
curl https://blocked-domain.com

# Should fail (iptables blocks proxy bypass)
curl --noproxy '*' https://github.com
```

### Restart Squid

```bash
squid -k reconfigure
```

## Known Limitations

- Changing `squid_port` from the default `3128` requires manually setting proxy environment variables, since `containerEnv` does not support option variable interpolation.
