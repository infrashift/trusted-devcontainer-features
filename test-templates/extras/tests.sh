#!/usr/bin/env bash
source "$(dirname "$0")/test-lib.sh"
check "node" node --version
# extras installs nodejs WITHOUT the npm feature, so this is what proves the
# nodejs feature replaced the npm bundled with Node.js (10.9.9 for 22.23.4).
check "npm is the nodejs feature's npm_version, not the bundled one" \
    bash -c 'npm --version | grep -qx "12\.2\.1"'
check "bun" bun --version
check "claude" claude --version
check "codex" codex --version
report_results
