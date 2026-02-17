#!/bin/bash
set -e
source dev-container-features-test-lib
check "node is installed" node --version
check "pnpm is installed" pnpm --version
reportResults
