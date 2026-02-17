#!/bin/bash
set -e
source dev-container-features-test-lib
check "uv is installed" uv --version
check "python3 is installed" python3 --version
reportResults
