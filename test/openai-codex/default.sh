#!/bin/bash
set -e
source dev-container-features-test-lib
check "bun is installed" bun --version
check "codex is installed" codex --version
reportResults
