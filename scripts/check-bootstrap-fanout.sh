#!/usr/bin/env bash
# If bootstrap's version changed, every feature that dependsOn it must change too.
#
# THE COST OF PINNING dependsOn BY DIGEST
#
# A digest pin is immutable, which is the point -- and also the problem. Before
# pinning, every feature's dependsOn resolved to bootstrap:latest, so a bootstrap
# fix reached consumers the moment it published. Now a dependent carries a
# specific bootstrap digest until that dependent is itself republished.
#
# devcontainers/action only publishes a feature whose VERSION changed. So
# bumping bootstrap alone publishes new bootstrap bytes that nothing points at:
# all 19 dependents keep pinning the previous digest, indefinitely, while the
# release log reports success.
#
# This makes that state unreachable. Bump bootstrap, and every dependent must be
# bumped in the same change.
#
# Usage: check-bootstrap-fanout.sh <base-ref>
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1

BASE="${1:?usage: check-bootstrap-fanout.sh <base-ref>}"

version_at() {  # <ref> <path>   empty if absent
    git show "${1}:${2}" 2>/dev/null | python3 -c '
import json, re, sys
try:
    print(json.loads(re.sub(r"(?m)^\s*//.*$", "", sys.stdin.read())).get("version", ""))
except Exception:
    pass' || true
}

BOOT_NEW=$(python3 -c '
import json, re
print(json.loads(re.sub(r"(?m)^\s*//.*$", "", open("src/bootstrap/devcontainer-feature.json").read()))["version"])')
BOOT_OLD=$(version_at "$BASE" "src/bootstrap/devcontainer-feature.json")

if [ -z "$BOOT_OLD" ]; then
    echo "bootstrap has no version at ${BASE}; nothing to compare"
    exit 0
fi

if [ "$BOOT_NEW" = "$BOOT_OLD" ]; then
    echo "OK: bootstrap unchanged at ${BOOT_NEW}; dependents need no bump"
    exit 0
fi

echo "bootstrap ${BOOT_OLD} -> ${BOOT_NEW}; every dependent must be bumped in the same change"

stale=()
checked=0
for d in src/*/; do
    feat=$(basename "$d")
    if [ "$feat" = "bootstrap" ] || [ "$feat" = "SKELETON-feature" ]; then continue; fi
    json="${d}devcontainer-feature.json"
    [ -f "$json" ] || continue
    grep -q '"dependsOn"' "$json" || continue

    checked=$((checked + 1))
    new=$(python3 -c "
import json, re
print(json.loads(re.sub(r'(?m)^\s*//.*\$', '', open('$json').read())).get('version',''))")
    old=$(version_at "$BASE" "$json")
    if [ -n "$old" ] && [ "$new" = "$old" ]; then
        stale+=("${feat} (still ${new})")
    fi
done

[ "$checked" -gt 0 ] || { echo "::error::found 0 dependents; refusing to call that a pass" >&2; exit 1; }

if [ "${#stale[@]}" -gt 0 ]; then
    echo "::error::bootstrap changed but these dependents did not, so they would keep pinning the old digest:" >&2
    printf '           %s\n' "${stale[@]}" >&2
    exit 1
fi

echo "OK: all ${checked} dependent(s) bumped alongside bootstrap"
