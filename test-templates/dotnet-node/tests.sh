#!/usr/bin/env bash
source "$(dirname "$0")/test-lib.sh"
check "make" make --version
check "dotnet" dotnet --version
# Lower case, and `/version' rather than `--version': `SqlPackage' is the .NET
# Framework spelling and does not resolve on Linux.
check "sqlpackage" sqlpackage /version
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
