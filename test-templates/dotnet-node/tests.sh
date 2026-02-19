#!/usr/bin/env bash
source "$(dirname "$0")/test-lib.sh"
check "dotnet" dotnet --version
check "node" node --version
check "npm" npm --version
check "pnpm" pnpm --version
check "git" git --version
check "git-lfs" git-lfs --version
check "grype" grype version
check "syft" syft version
check "jq" jq --version
check "yq" yq --version
report_results
