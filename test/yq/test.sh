#!/bin/bash
set -e
source dev-container-features-test-lib
check "yq is installed" yq --version
reportResults
