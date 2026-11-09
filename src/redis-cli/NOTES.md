# redis-cli Feature

Installs `redis-cli` as the [Valkey](https://valkey.io/) CLI. `valkey-cli` speaks the Redis protocol (RESP2 and RESP3) and accepts the `redis-cli` flags, so it connects to Redis and to Valkey servers.

## Why Valkey

* Redis publishes no prebuilt CLI binaries. Only source tarballs and distribution packages are available.
* Fedora 43 replaced its `redis` package with Valkey. `valkey-compat-redis` supplies `redis-cli` as a link to `valkey-cli`, but a dnf install cannot pin the version.
* Valkey publishes release tarballs for `x86_64` and `arm64`, with a `.sha256` file for each. This role pins the version and the SHA256 for each architecture (ADR-006).

## Install Location

- Binary: `~/.local/share/valkey/<version>/valkey-cli` (with its `LICENSE`)
- Links: `~/.local/bin/valkey-cli` and `~/.local/bin/redis-cli`

Only `valkey-cli` is installed. The server, sentinel and benchmark binaries are not.

## Architectures and variants

The role maps `_target_arch` (`amd64`, `arm64`) to the Valkey arch name (`x86_64`, `arm64`). It uses the `jammy` builds. Their highest glibc symbol is `GLIBC_2.34`, and they link only `libc`, `libm`, `libssl.so.3` and `libcrypto.so.3`. Thus they run on UBI 9 (glibc 2.34), UBI 10 and Fedora 43. The `noble` builds need glibc 2.39.

## Version output

`redis-cli --version` prints `valkey-cli <version> (git:<sha>)`. The role and the tests compare the version token.

## Add a version

```bash
for a in x86_64 arm64; do
  f=valkey-<ver>-jammy-$a.tar.gz
  curl -fsSLO https://download.valkey.io/releases/$f
  curl -fsSLO https://download.valkey.io/releases/$f.sha256
done
sha256sum -c *.sha256
tar xzf <tarball> --wildcards '*/bin/valkey-cli'
objdump -T */bin/valkey-cli | grep -oE 'GLIBC_[0-9.]+' | sort -uV | tail -1   # must be <= 2.34
```

Add the two digests to `_redis_cli_pinned_checksums` in `ansible-role-feature/vars/main.yml`, keyed by `amd64` and `arm64`.

## Versions

See the releases at https://valkey.io/download/
