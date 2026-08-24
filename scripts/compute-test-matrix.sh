#!/usr/bin/env bash
# Decide which test templates need building for a given change.
#
# Every PR built all six templates regardless of what changed. A one-line edit to
# the openjdk role rebuilt five containers that never install openjdk.
#
# The feature -> template mapping is DERIVED by reading each test template's
# devcontainer.json, never written down here. A hardcoded table would be one more
# copy of a contract that drifts, and this repository has spent a lot of effort
# discovering copies exactly like it.
#
# Usage: compute-test-matrix.sh <base-ref>   JSON array of {template, arch, runner}
#        compute-test-matrix.sh --all        every template, both architectures
#
# ARCHITECTURE. Every role derives its download from the _target_arch the runner
# injects, and every checksum table is keyed by version AND arch -- but no arm64
# image had ever been built, so every arm64 digest in those tables was a value
# nothing had ever checked. Each selected template is built on both, on native
# runners: amd64 on ubuntu-latest, arm64 on ubuntu-24.04-arm. Native rather than
# qemu because these roles EXECUTE the binaries they install to assert versions,
# and emulation makes a failure ambiguous between the tool and the emulator.
#
# FULL MATRIX whenever a shared input changes, because the blast radius is
# everything:
#   src/bootstrap/            every template installs it
#   test-templates/shared/    the Containerfile, contract tests, test-lib
#   scripts/, tools.lock      how anything gets installed at all
#   the workflow itself
#
# Every fallback is toward MORE building, never less. A matrix computer that
# returns an empty set when it is confused reports a clean run for a change
# nobody tested.
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1

all_templates() {
    find test-templates -mindepth 1 -maxdepth 1 -type d -printf '%f\n' \
      | grep -v '^shared$' | sort
}

# One entry per template per architecture. The runner label travels with the
# entry so the workflow never has to map arch -> runner itself, which would be a
# second copy of this decision.
expand() {
    jq -R . | jq -s -c '[ .[] as $t | ("amd64","arm64") as $a |
        {template: $t, arch: $a,
         runner: (if $a == "arm64" then "ubuntu-24.04-arm" else "ubuntu-latest" end)} ]'
}

emit_all() { all_templates | expand; }

if [ "${1:-}" = "--all" ]; then emit_all; exit 0; fi

BASE="${1:?usage: compute-test-matrix.sh <base-ref> | --all}"

if ! CHANGED=$(git diff --name-only "$BASE" HEAD 2>/dev/null); then
    echo "warning: cannot diff against ${BASE}; building every template" >&2
    emit_all; exit 0
fi

if [ -z "$CHANGED" ]; then
    echo "no files changed; building every template" >&2
    emit_all; exit 0
fi

if grep -qE '^(src/bootstrap/|test-templates/shared/|scripts/|tools\.lock$|\.github/workflows/test-templates\.yaml$)' <<<"$CHANGED"; then
    echo "shared input changed; building every template" >&2
    emit_all; exit 0
fi

mapfile -t CHANGED_FEATURES < <(grep -oP '^src/\K[^/]+' <<<"$CHANGED" | sort -u || true)
mapfile -t TOUCHED < <(grep -oP '^test-templates/\K[^/]+' <<<"$CHANGED" | grep -v '^shared$' | sort -u || true)

selected=()
while IFS= read -r t; do
    json="test-templates/${t}/.devcontainer/devcontainer.json"
    [ -f "$json" ] || continue

    hit=0
    for touched in ${TOUCHED[@]+"${TOUCHED[@]}"}; do
        [ "$touched" = "$t" ] && hit=1 && break
    done

    if [ "$hit" -eq 0 ] && [ "${#CHANGED_FEATURES[@]}" -gt 0 ]; then
        mapfile -t installs < <(python3 - "$json" <<'PYEOF' 2>/dev/null || true
import json, re, sys
doc = json.loads(re.sub(r'(?m)^\s*//.*$', '', open(sys.argv[1]).read()))
for ref in (doc.get("features") or {}):
    print(ref.split("@")[0].lstrip("./").rsplit("/", 1)[-1])
PYEOF
)
        for f in "${CHANGED_FEATURES[@]}"; do
            for i in ${installs[@]+"${installs[@]}"}; do
                [ "$f" = "$i" ] && hit=1 && break 2
            done
        done
    fi

    [ "$hit" -eq 1 ] && selected+=("$t")
done < <(all_templates)

if [ "${#selected[@]}" -eq 0 ]; then
    echo "no template installs any changed feature" >&2
    echo '[]'
    exit 0
fi

printf '%s\n' "${selected[@]}" | sort -u | expand
