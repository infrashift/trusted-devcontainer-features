#!/bin/bash
set -e
source dev-container-features-test-lib
check "git is installed" git --version
check "git-lfs is installed" git-lfs --version
check "go is installed" go version
check "cue is installed" cue version
check "jq is installed" jq --version
check "yq is installed" yq --version
check "uv is installed" uv --version
check "ruff is installed" ruff --version
check "grype is installed" grype version
check "syft is installed" syft version
check "node is installed" node --version
check "npm is installed" npm --version
check "bun is installed" bun --version
check "claude is installed" claude --version
check "codex is installed" codex --version
check "pnpm is installed" pnpm --version
check "python3 is installed" python3 --version
check "ansible is installed" ansible --version
check "java is installed" java -version
check "dotnet is installed" dotnet --version
reportResults
