#!/usr/bin/env bash
source "$(dirname "$0")/test-lib.sh"
check "java" java -version
check "git" git --version
check "git-lfs" git-lfs --version
check "grype" grype version
check "syft" syft version
check "jq" jq --version
check "yq" yq --version
report_results
