#!/usr/bin/env bash
source "$(dirname "$0")/test-lib.sh"
check "node" node --version
check "bun" bun --version
check "claude" claude --version
check "codex" codex --version
report_results
