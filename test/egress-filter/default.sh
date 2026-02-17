#!/bin/bash
set -e
source dev-container-features-test-lib
check "squid config is valid" squid -k parse
check "iptables is installed" which iptables
reportResults
