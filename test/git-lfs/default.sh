#!/bin/bash
set -e
source dev-container-features-test-lib
check "git is installed" git --version
check "git-lfs is installed" git-lfs --version
reportResults
