#!/usr/bin/env bash
source "$(dirname "$0")/test-lib.sh"
check "ansible" ansible --version
check "python" uv python find 3.12
check "cue" cue version
check "git" git --version
check "git-lfs" git-lfs --version
check "grype" grype version
check "syft" syft version
check "jq" jq --version
check "yq" yq --version
report_results
