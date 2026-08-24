#!/usr/bin/env bash
# Read each published feature's metadata back OUT of the registry and fail if it
# carries a relative dependency reference.
#
# This is the check that was missing. scripts/rewrite-feature-refs.sh asserts its
# own output, but an assertion a script makes about itself only proves the script
# ran -- it cannot prove that what reached the registry is what the script
# produced. The first release published "dependsOn": {"./bootstrap": {}} to all
# 19 dependent features and every test in this repository stayed green, because
# every test here stages features locally where ./bootstrap resolves.
#
# So this reads the artifact a consumer would actually pull. A relative ref in
# published metadata resolves against the CONSUMER's .devcontainer/ folder and
# fails there with an ENOENT naming a path inside THEIR repo -- an error that
# gives them nothing to act on.
#
# Required env: FEATURES GITHUB_REPOSITORY
set -euo pipefail

: "${FEATURES:?}" "${GITHUB_REPOSITORY:?}"
REGISTRY="${REGISTRY:-ghcr.io}"
repo="${GITHUB_REPOSITORY,,}"

fail=0
checked=0

while IFS= read -r feature; do
    [ -n "$feature" ] || continue
    [[ "$feature" =~ ^[a-z0-9][a-z0-9-]{0,63}$ ]] || {
        echo "::error::refusing to inspect a feature named ${feature@Q}" >&2; exit 1; }

    ref="${REGISTRY}/${repo}/${feature}:latest"

    # regctl would be tidier, but cosign is already installed in this job and
    # `crane manifest` gives us the annotation without another tool.
    meta="$(crane manifest "$ref" 2>/dev/null | jq -r '.annotations["dev.containers.metadata"] // empty')"
    if [ -z "$meta" ]; then
        echo "::error::${feature}: no dev.containers.metadata annotation on ${ref}" >&2
        fail=1
        continue
    fi

    checked=$((checked + 1))

    relative="$(jq -r '
        [ (.installsAfter // [])[],
          ((.dependsOn // {}) | keys[]) ]
        | map(select(startswith("./")))
        | join(", ")' <<<"$meta")"

    if [ -n "$relative" ]; then
        echo "::error::${feature} published with relative reference(s): ${relative}" >&2
        echo "           A consumer resolves these against their own .devcontainer/ and gets ENOENT." >&2
        fail=1
    else
        echo "  ok ${feature}"
    fi
done < <(jq -r '.[]' <<<"$FEATURES")

[ "$checked" -gt 0 ] || { echo "::error::inspected 0 features; refusing to call that a pass" >&2; exit 1; }

if [ "$fail" -eq 0 ]; then
    echo "OK: ${checked} published feature(s) carry no relative references"
else
    exit 1
fi
