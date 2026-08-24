#!/usr/bin/env bash
# Assert that the versions pinned in contract-tests.sh ROLE_ARGS still match the
# defaults declared in each feature's devcontainer-feature.json.
#
# ROLE_ARGS exists because the contract tests must invoke each role with the
# same extra-vars install.sh would pass. That makes it a SECOND copy of every
# default, and nothing kept the two in step: syft, grype, jq and yq were bumped
# and the contract tests went on asserting idempotency against the previous
# versions -- which still passes, because a role is idempotent at whatever
# version you hand it. A test that passes while checking the wrong thing.
#
# Comparing value sets rather than variable names on purpose: role arg names do
# not map cleanly onto option names (_openjdk_major_version, _cue_version), and
# a name-based mapping is another table to keep in step.
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1

TESTS="test-templates/shared/contract-tests.sh"
[ -f "$TESTS" ] || { echo "::error::${TESTS} not found" >&2; exit 1; }

fail=0
checked=0

# Every ROLE_ARGS entry that pins at least one version.
while IFS= read -r line; do
    feat="$(sed -E 's/^[[:space:]]*\[([a-z0-9-]+)\].*/\1/' <<<"$line")"
    [ -n "$feat" ] || continue
    json="src/${feat}/devcontainer-feature.json"
    [ -f "$json" ] || continue

    # Declared defaults for this feature, as a plain set of values.
    mapfile -t declared < <(grep -oP '"default"\s*:\s*"\K[^"]+' "$json" | sort -u)
    [ "${#declared[@]}" -gt 0 ] || continue

    # Every version-shaped value pinned for this feature in ROLE_ARGS.
    while IFS= read -r pinned; do
        [ -n "$pinned" ] || continue
        checked=$((checked + 1))
        found=0
        for d in "${declared[@]}"; do [ "$d" = "$pinned" ] && found=1 && break; done
        if [ "$found" -eq 0 ]; then
            echo "::error::${feat}: contract tests pin ${pinned}, which is not a declared default in ${json}" >&2
            echo "           declared: ${declared[*]}" >&2
            fail=1
        fi
    done < <(grep -oE "_[a-z0-9_]+_version=[^ ']+" <<<"$line" | sed "s/.*=//")
done < <(sed -n '/^declare -A ROLE_ARGS=(/,/^)/p' "$TESTS" | grep -E "^\s*\[[a-z0-9-]+\]='")

[ "$checked" -gt 0 ] || { echo "::error::checked 0 pins; refusing to call that a pass" >&2; exit 1; }
[ "$fail" -eq 0 ] || exit 1
echo "OK: ${checked} contract-test version pin(s) match their declared defaults"
