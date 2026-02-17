#!/bin/bash
set -e
source dev-container-features-test-lib
check "go is installed" go version
check "cue is installed" cue version
reportResults
