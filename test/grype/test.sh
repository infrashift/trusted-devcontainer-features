#!/bin/bash
set -e
source dev-container-features-test-lib
check "grype is installed" grype version
reportResults
