#!/bin/bash
set -e
source dev-container-features-test-lib
check "jq is installed" jq --version
reportResults
