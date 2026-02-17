#!/bin/bash
set -e
source dev-container-features-test-lib
check "bun is installed" bun --version
check "claude is installed" claude --version
reportResults
