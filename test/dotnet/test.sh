#!/bin/bash
set -e
source dev-container-features-test-lib
check "dotnet is installed" dotnet --version
reportResults
