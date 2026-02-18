#!/bin/bash
set -e
source dev-container-features-test-lib
check "sudo is installed" sudo --version
check "passwordless sudo works" sudo -n true
reportResults
