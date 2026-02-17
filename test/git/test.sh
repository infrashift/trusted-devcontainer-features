#!/bin/bash
set -e
source dev-container-features-test-lib
check "git is installed" git --version
reportResults
