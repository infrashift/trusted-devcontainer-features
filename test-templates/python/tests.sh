#!/usr/bin/env bash
source "$(dirname "$0")/test-lib.sh"
check "python" uv python find 3.12
check "uv" uv --version
check "ruff" ruff --version
check "git" git --version
check "git-lfs" git-lfs --version
check "grype" grype version
check "syft" syft version
check "jq" jq --version
check "yq" yq --version
report_results
