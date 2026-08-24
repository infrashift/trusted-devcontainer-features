#!/usr/bin/env bash
# Rewrite local feature references to published OCI references, in place, in
# preparation for publishing.
#
# WHY THIS EXISTS
#
# Features declare their dependencies relatively:
#
#     "installsAfter": ["./uv-ruff"],
#     "dependsOn": { "./bootstrap": {} }
#
# That is correct *in this repository*, where the test templates stage src/*
# into .devcontainer/ and reference features as ./python, ./bootstrap and so on.
# It is what lets `make test` exercise the working tree rather than the last
# release, which matters most for bootstrap -- the runner every other feature
# depends on.
#
# It is wrong the moment those bytes are published. A relative path is resolved
# against the CONSUMER's devcontainer.json folder, so a template that pulls
# ghcr.io/.../python gets:
#
#     ENOENT: .../src/python/.devcontainer/bootstrap/devcontainer-feature.json
#
# The first release shipped exactly this. Nothing in this repo could catch it:
# every test here stages features locally, so ./bootstrap always resolves. It
# only fails at an external consumer.
#
# So the source keeps the relative form and this script rewrites it at publish
# time -- the same local/published split scripts/prepare-devcontainer.sh and the
# test-template staging already use.
#
# devcontainer-feature.json is JSONC (it opens with // comments), so jq and yq
# both refuse to parse it. Hence sed on an exact-match pattern rather than a
# structural edit.
#
# USAGE
#   rewrite-feature-refs.sh            rewrite in place (publish time)
#   rewrite-feature-refs.sh --check    validate only, touch nothing (PR time)
#
# --check is what pr-gate runs. It catches the failure this script cannot fix --
# a reference to a feature that does not exist -- at review time rather than
# mid-release.
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1

CHECK_ONLY=0
if [ "${1:-}" = "--check" ]; then
    CHECK_ONLY=1
    # Nothing is written, so a real registry name is not needed to validate.
    GITHUB_REPOSITORY="${GITHUB_REPOSITORY:-owner/repo}"
fi

# ghcr.io references must be lowercase.
REPO="${GITHUB_REPOSITORY:?GITHUB_REPOSITORY is required (owner/repo)}"
REGISTRY="${REGISTRY:-ghcr.io}"
BASE="${REGISTRY}/${REPO,,}"

# Every feature id that actually exists, so a typo'd reference fails by name
# rather than being rewritten into a URL that 404s at a consumer months later.
mapfile -t IDS < <(find src -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort)
[ "${#IDS[@]}" -gt 0 ] || { echo "::error::no features found under src/" >&2; exit 1; }

declare -A KNOWN=()
for id in "${IDS[@]}"; do KNOWN["$id"]=1; done

rewritten=0
files=0

for f in src/*/devcontainer-feature.json; do
    [ -f "$f" ] || continue

    # Collect the relative refs this file declares, and validate them first.
    mapfile -t refs < <(grep -o '"\./[a-zA-Z0-9._-]*"' "$f" | tr -d '"./' | sort -u)
    bad=0
    for r in "${refs[@]}"; do
        [ -n "$r" ] || continue
        if [ -z "${KNOWN[$r]:-}" ]; then
            echo "::error::${f} references ./${r}, which is not a feature under src/" >&2
            bad=1
        fi
    done
    [ "$bad" -eq 0 ] || exit 1

    n=0
    for r in "${refs[@]}"; do
        [ -n "$r" ] || continue
        if [ "$CHECK_ONLY" -eq 0 ]; then
            # Exact match on the quoted token, so "./bun" never matches "./bundler".
            sed -i "s|\"\./${r}\"|\"${BASE}/${r}\"|g" "$f"
        fi
        n=$((n + 1))
    done

    # dependsOn is a FETCH -- the CLI pulls that feature and runs its install.sh.
    # installsAfter is only an ordering hint among features the consumer already
    # selected, and it is matched by id, so a digest there could fail to match a
    # consumer who pinned a different digest of the same sibling. Only dependsOn
    # gets a digest.
    if [ "$CHECK_ONLY" -eq 0 ] && [ -n "${BOOTSTRAP_DIGEST:-}" ]; then
        python3 - "$f" "${BASE}/bootstrap" "${BOOTSTRAP_DIGEST}" <<'PYEOF'
import json, re, sys
path, ref, digest = sys.argv[1], sys.argv[2], sys.argv[3]
raw = open(path).read()
# Only inside the dependsOn block; installsAfter must keep the bare reference.
m = re.search(r'("dependsOn"\s*:\s*\{)([^}]*)(\})', raw, re.S)
if m:
    body = m.group(2).replace(f'"{ref}"', f'"{ref}@{digest}"')
    raw = raw[:m.start(2)] + body + raw[m.end(2):]
    open(path, "w").write(raw)
PYEOF
    fi

    if [ "$n" -gt 0 ]; then
        files=$((files + 1))
        rewritten=$((rewritten + n))
        if [ "$CHECK_ONLY" -eq 1 ]; then
            echo "  ${f}: ${n} reference(s) ok"
        else
            echo "  ${f}: ${n} reference(s) -> ${BASE}/*"
        fi
    fi
done

if [ "$CHECK_ONLY" -eq 1 ]; then
    echo "OK: ${rewritten} relative reference(s) across ${files} file(s) all resolve to features under src/"
    exit 0
fi

# Fail loudly if anything relative survived. The check is on the OUTPUT, not on
# whether the loop above thought it did something.
if grep -l '"\./' src/*/devcontainer-feature.json 2>/dev/null; then
    echo "::error::relative references remain in the files listed above" >&2
    exit 1
fi

if [ -n "${BOOTSTRAP_DIGEST:-}" ]; then
    # Every dependsOn must now carry the digest. A feature that quietly kept a
    # tag reference would pin nothing while looking pinned.
    missing=$(grep -L "\"${BASE}/bootstrap@${BOOTSTRAP_DIGEST}\"" src/*/devcontainer-feature.json \
              | xargs -r grep -l '"dependsOn"' || true)
    if [ -n "$missing" ]; then
        echo "::error::these declare dependsOn but did not receive the bootstrap digest:" >&2
        echo "$missing" | sed 's/^/           /' >&2
        exit 1
    fi
    echo "pinned dependsOn -> bootstrap@${BOOTSTRAP_DIGEST}"
fi

echo "rewrote ${rewritten} reference(s) across ${files} file(s) to ${BASE}"
