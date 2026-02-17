#!/bin/bash
set -e
source dev-container-features-test-lib
check "python3 is installed" python3 --version
check "ansible is installed" ansible --version
reportResults
