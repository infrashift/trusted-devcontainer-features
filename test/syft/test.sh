#!/bin/bash
set -e
source dev-container-features-test-lib
check "syft is installed" syft version
reportResults
