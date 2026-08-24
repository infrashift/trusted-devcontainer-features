#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# test-templates/shared/contract-tests.sh
# Licensed under the MIT License.
#-------------------------------------------------------------------------------------------------------------
#
# Usage: contract-tests.sh <template>
#
# Tests the parts of the role contract that tests.sh cannot: that re-running a
# role changes nothing, and that a missing, empty, or wrong parameter fails
# loudly and by name. Those behaviours are the entire point of the contract, and
# without this they are only ever verified by hand.
#
# This runs on the HOST, not inside the container, because it needs root:
# /opt/bootstrap/run-feature.sh chowns and calls setpriv. `devcontainer exec`
# resolves to the unprivileged `dev` user (every template sets containerUser: dev
# and none sets remoteUser) and offers no --user flag, so the only route is
# `docker exec -u 0` against the container found by its id-label.
#
set -uo pipefail

TEMPLATE="${1:?usage: contract-tests.sh <template>}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "${HERE}/test-lib.sh"

CID="$(docker ps -q --filter "label=test=${TEMPLATE}" | head -1)"
if [ -z "${CID}" ]; then
    echo "ERROR: no running container labelled test=${TEMPLATE}." >&2
    echo "Run: devcontainer up --workspace-folder test-templates/${TEMPLATE} --id-label test=${TEMPLATE}" >&2
    exit 1
fi

# The repo is bind-mounted by the CLI's workspace-git-root mount, which is how
# the roles are reachable at all. Assert it rather than skipping silently -- a
# contract test that quietly does nothing is worse than no contract test.
#
# The mount lands at /workspaces/<basename of the git root>, and that basename is
# the CLONE DIRECTORY name, not the repository name. This checkout is usually
# `devcontainer-features`, while Actions checks out into
# `trusted-devcontainer-features`. Hardcoding either one is green in exactly one
# of those places, which is why this passed locally and failed on the first CI
# run. Derive it instead.
REPO_IN_CTR="/workspaces/$(basename "$(git -C "${HERE}" rev-parse --show-toplevel)")"

if ! docker exec "${CID}" test -d "${REPO_IN_CTR}/src"; then
    # Fall back to discovery, so a change in how the CLI names the mount costs a
    # slower lookup rather than a red build. Matches on both src/ and
    # test-templates/ so it cannot latch onto an unrelated workspace.
    REPO_IN_CTR="$(docker exec "${CID}" sh -c \
        'for d in /workspaces/*/; do
             if [ -d "${d}src" ] && [ -d "${d}test-templates" ]; then printf "%s" "${d%/}"; break; fi
         done')"
fi

if [ -z "${REPO_IN_CTR}" ] || ! docker exec "${CID}" test -d "${REPO_IN_CTR}/src"; then
    echo "ERROR: could not find this repository's mount inside the container." >&2
    echo "Looked for a /workspaces/* directory containing both src/ and test-templates/." >&2
    echo "The workspace bind-mount changed; contract tests cannot reach the roles." >&2
    docker exec "${CID}" ls -la /workspaces/ >&2 || true
    exit 1
fi
echo "contract tests using ${REPO_IN_CTR}"

# _REMOTE_USER/_REMOTE_USER_HOME are injected by the devcontainer CLI only during
# feature installation, never into an exec environment, so pass them explicitly.
# run-feature.sh resolves the role relative to $(pwd), hence -w.
run_role() {
    local feature="$1"; shift
    docker exec -u 0 -w "${REPO_IN_CTR}/src/${feature}" \
        -e _REMOTE_USER=dev -e _REMOTE_USER_HOME=/home/dev \
        "${CID}" /opt/bootstrap/run-feature.sh --role ansible-role-feature "$@"
}

run_install() {
    local feature="$1"; shift
    local envs=(); for kv in "$@"; do envs+=(-e "$kv"); done
    docker exec -u 0 -w "${REPO_IN_CTR}/src/${feature}" \
        -e _REMOTE_USER=dev -e _REMOTE_USER_HOME=/home/dev \
        "${envs[@]}" "${CID}" bash ./install.sh
}

# Re-running a role must report changed=0 (ADR-012 idempotency contract).
assert_idempotent() {
    local feature="$1"; shift
    local out; out="$(run_role "$feature" "$@" 2>&1)"
    if [[ "$out" != *"changed=0"* ]]; then
        echo "${out}" | grep -E "changed=|fatal:" | tail -3
        return 1
    fi
    return 0
}

echo "Contract tests: ${TEMPLATE} (container ${CID})"
echo ""
echo "Idempotency — a second run must change nothing:"

# Feature -> the extra-vars its install.sh passes, at their declared defaults.
declare -A ROLE_ARGS=(
  [python]='-e _python_version=3.13'
  [cuelang]='-e _cue_version=0.17.1 -e _cue_checksum='
  [golang]='-e _go_version=1.27.0 -e _go_checksum='
  [grype]='-e _grype_version=0.117.0 -e _grype_checksum='
  [syft]='-e _syft_version=1.51.0 -e _syft_checksum='
  [jq]='-e _jq_version=1.8.2 -e _jq_checksum='
  [yq]='-e _yq_version=4.53.6 -e _yq_checksum='
  [nodejs]='-e _nodejs_version=22.23.2 -e _nodejs_checksum='
  [npm]='-e _npm_version=12.0.2'
  [pnpm]='-e _pnpm_version=10.12.1 -e _pnpm_checksum='
  [bun]='-e _bun_version=1.2.17 -e _bun_checksum='
  [dotnet]='-e _dotnet_version=8.0.424 -e _dotnet_checksum='
  [openjdk]='-e _openjdk_major_version=21 -e _openjdk_version=21.0.12.1+1 -e _openjdk_checksum='
  [uv-ruff]='-e _uv_version=0.12.5 -e _uv_checksum= -e _ruff_version=0.16.4'
  [ansible-core]='-e _ansible_core_version=2.21.3 -e _ansible_core_python_version=3.13'
  # Filled in below from what is actually installed -- see the note there.
  [claude-code]=''
  [openai-codex]=''
  [git]='' [git-lfs]=''
)

# claude-code and openai-codex take the npm dist-tag "latest", which the role now
# resolves to a concrete version on every run. Passing "latest" here would make
# the idempotency check race an npm publish between the image build and this
# test, so pin each to whatever the image actually ended up with. The resolution
# path itself is exercised by the build.
installed_semver() {
    docker exec -u dev "${CID}" bash -lc "$1 2>/dev/null" 2>/dev/null \
        | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1 || true
}
_cc="$(installed_semver '~/.bun/bin/claude --version' || true)"
_cx="$(installed_semver '~/.bun/bin/codex --version' || true)"
if [ -n "${_cc}" ]; then ROLE_ARGS[claude-code]="-e _claude_code_version=${_cc}"; fi
if [ -n "${_cx}" ]; then ROLE_ARGS[openai-codex]="-e _codex_version=${_cx}"; fi

# Only the features this template actually installs.
CONF="${HERE}/../${TEMPLATE}/.devcontainer/devcontainer.json"
mapfile -t FEATURES < <(grep -oE '"\./[a-z0-9-]+"' "$CONF" | tr -d '".' | sed 's|/||' | grep -v '^bootstrap$')

for f in "${FEATURES[@]}"; do
    [[ -v ROLE_ARGS[$f] ]] || { echo "  SKIP: no args recorded for '$f'"; continue; }
    # shellcheck disable=SC2086
    check "idempotent: ${f}" assert_idempotent "$f" ${ROLE_ARGS[$f]}
done

echo ""
echo "Failure modes — each must fail by name, before any work:"

# One representative of each checksum shape present in this template.
if [[ " ${FEATURES[*]} " == *" cuelang "* ]]; then
    check_fails "missing -e is named" "_cue_checksum is defined" \
        run_role cuelang -e _cue_version=0.17.1
    check_fails "empty mandatory option stops in the shell" "resolved empty" \
        run_install cuelang TARGET_VERSION= TARGET_CHECKSUM=
    check_fails "unpinned version refuses to download unverified" "No SHA256 is pinned" \
        run_role cuelang -e _cue_version=0.14.1 -e _cue_checksum=
    check_fails "malformed checksum is rejected by shape" "must be a 64-character SHA256" \
        run_role cuelang -e _cue_version=0.17.1 -e _cue_checksum=deadbeef
    check_fails "malformed version is rejected by shape" "must look like X.Y.Z" \
        run_role cuelang -e _cue_version=0.15 -e _cue_checksum=
fi

if [[ " ${FEATURES[*]} " == *" grype "* ]]; then
    check_fails "checksums-file role names its missing param" "_grype_checksum is defined" \
        run_role grype -e _grype_version=0.117.0
fi

if [[ " ${FEATURES[*]} " == *" python "* ]]; then
    check_fails "no-checksum role names its missing param" "required role parameter" \
        run_role python
fi

# The runner contract itself: without the CLI-injected identity there is no safe default.
check_fails "role run outside run-feature.sh is refused" "_REMOTE_USER" \
    docker exec -u 0 -w "${REPO_IN_CTR}/src/jq" "${CID}" /opt/bootstrap/run-feature.sh --role ansible-role-feature

report_results
