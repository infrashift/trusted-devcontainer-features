#!/usr/bin/env bash
# Report how far each pinned feature default has drifted from its upstream latest.
#
# WHY THIS EXISTS
#
# The templates repo's CVE gate stopped blocking on dependencies vendored inside
# artifacts we cannot rebuild -- a stdlib finding in the grype binary is fixed by
# nobody but Anchore. That is correct, but it rests on an assumption: that the
# ARTIFACTS themselves are kept current. Nothing checked that.
#
# Both refresh rounds found tools badly behind -- syft 1.42 against 1.51, grype
# 0.108 against 0.117, cue 0.15.4 against 0.17.1 -- and both were found by
# reading a CVE report, not by a check. Now that those findings are recorded
# rather than blocking, the next drift has nothing to announce it.
#
# WARNS, DOES NOT BLOCK, BY DEFAULT
#
# A release published an hour ago should not fail a build. Drift is reported and
# summarised; pass --max-behind N to fail when any tool is more than N releases
# behind, for use once a threshold has been agreed.
#
# Network failures are reported as "unknown", never as "current". A currency
# check that silently passes when it cannot reach upstream is the failure this
# repository keeps rediscovering.
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1

MAX_BEHIND=""
[ "${1:-}" = "--max-behind" ] && MAX_BEHIND="${2:?--max-behind needs a number}"

# feature -> how to resolve the newest upstream version.
# Deliberately explicit: every upstream names releases differently, and guessing
# is how you end up comparing a tag to a version and calling it drift.
latest_for() {
    case "$1" in
        syft)         gh_tag anchore/syft            'sed s/^v//' ;;
        grype)        gh_tag anchore/grype           'sed s/^v//' ;;
        jq)           gh_tag jqlang/jq               'sed s/^jq-//' ;;
        yq)           gh_tag mikefarah/yq            'sed s/^v//' ;;
        cuelang)      gh_tag cue-lang/cue            'sed s/^v//' ;;
        golang)       curl -sSfL --max-time 20 'https://go.dev/dl/?mode=json' | jq -r '.[0].version' | sed 's/^go//' ;;
        bun)          gh_tag oven-sh/bun             'sed s/^bun-v//' ;;
        uv-ruff)      gh_tag astral-sh/uv            'cat' ;;
        npm)          npm_dist npm ;;
        pnpm)         npm_dist pnpm ;;
        ansible-core) curl -sSfL --max-time 20 https://pypi.org/pypi/ansible-core/json | jq -r '.info.version' ;;

        # Resolved WITHIN the declared major line. Comparing node 22.23.2 against
        # 24.19.0 would report drift for a deliberate decision -- a major bump is
        # a behaviour change, and these templates advertise particular stacks.
        # Currency here means "newest patch on the line we chose".
        nodejs)  curl -sSfL --max-time 20 https://nodejs.org/dist/index.json \
                   | jq -r --arg m "v${2%%.*}." '[.[] | select(.version | startswith($m))][0].version' | sed 's/^v//' ;;
        dotnet)  curl -sSfL --max-time 20 "https://dotnetcli.blob.core.windows.net/dotnet/Sdk/${2%.*}/latest.version" | tail -1 ;;
        openjdk) curl -sSfL --max-time 20 \
                   "https://api.adoptium.net/v3/info/release_names?release_type=ga&version=%5B${2%%.*}%2C$(( ${2%%.*} + 1 ))%29&page_size=1&sort_order=DESC&vendor=eclipse" \
                   | jq -r '.releases[0]' | sed 's/^jdk-//' ;;

        *)            return 1 ;;
    esac
}

# Features whose pin is not a comparable release, with the reason. These are NOT
# unknowns: nothing failed, there is simply nothing to compare. Reporting them
# as unresolved would make the check look weaker than it is and train the reader
# to ignore the column.
not_comparable() {
    case "$1" in
        claude-code|openai-codex) echo "npm dist-tag 'latest', resolved at build time" ;;
        python|bootstrap)         echo "minor line, not a patch release" ;;
        *) return 1 ;;
    esac
}

gh_tag()  { curl -sSfL --max-time 20 "https://api.github.com/repos/$1/releases/latest" | jq -r '.tag_name' | eval "$2"; }
npm_dist() { curl -sSfL --max-time 20 "https://registry.npmjs.org/$1" | jq -r '."dist-tags".latest'; }

# devcontainer-feature.json is JSONC, and the option blocks span several lines --
# grep -P is line-based, so a pattern spanning `{ ... "default": ... }` matches
# nothing and returns empty for every feature. Strip the comments and parse.
declared_for() {
    python3 - "src/$1/devcontainer-feature.json" <<'PYEOF' 2>/dev/null || true
import json, re, sys
try:
    raw = open(sys.argv[1]).read()
except OSError:
    sys.exit(0)
# Only whole-line // comments appear in these files.
doc = json.loads(re.sub(r'(?m)^\s*//.*$', '', raw))
opts = doc.get("options", {})
for name in ("target_version", "target_uv_version", "python_version"):
    if name in opts and "default" in opts[name]:
        print(opts[name]["default"])
        break
PYEOF
}

behind=0
unknown=0
rows=""

for d in src/*/; do
    feat=$(basename "$d")
    # `[ ... ] && continue` returns 1 when the test is false, and under `set -e`
    # that exits the script silently. Use an if.
    if [ "$feat" = "SKELETON-feature" ]; then continue; fi

    have=$(declared_for "$feat" || true)
    [ -n "$have" ] || continue

    if reason=$(not_comparable "$feat"); then
        rows+="| \`${feat}\` | ${have} | — | n/a — ${reason} |"$'\n'
        continue
    fi

    if ! want=$(latest_for "$feat" "$have" 2>/dev/null) || [ -z "$want" ] || [ "$want" = "null" ]; then
        rows+="| \`${feat}\` | ${have} | — | unknown |"$'\n'
        unknown=$((unknown + 1))
        continue
    fi

    if [ "$have" = "$want" ]; then
        rows+="| \`${feat}\` | ${have} | ${want} | current |"$'\n'
    else
        rows+="| \`${feat}\` | ${have} | ${want} | **behind** |"$'\n'
        behind=$((behind + 1))
    fi
done

printf '| Feature | pinned | latest | |\n|---|---|---|---|\n%s' "$rows"
echo
echo "behind: ${behind}   unknown: ${unknown}"

if [ -n "${GITHUB_STEP_SUMMARY:-}" ]; then
    {
        echo "## Tool version currency"
        echo
        printf '| Feature | pinned | latest | |\n|---|---|---|---|\n%s' "$rows"
        echo
        echo "_Recorded, not blocking. The CVE gate records findings vendored inside these"
        echo "artifacts on the understanding that the artifacts are kept current; this is"
        echo "where that is visible._"
    } >> "$GITHUB_STEP_SUMMARY"
fi

if [ -n "$MAX_BEHIND" ] && [ "$behind" -gt "$MAX_BEHIND" ]; then
    echo "::error::${behind} feature(s) behind upstream, threshold is ${MAX_BEHIND}" >&2
    exit 1
fi

# An upstream we could not reach is reported, never counted as current.
[ "$unknown" -eq 0 ] || echo "::warning::${unknown} feature(s) could not be resolved upstream"
