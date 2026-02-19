#!/usr/bin/env bash
source "$(dirname "$0")/../shared/test-lib.sh"
check "node" node --version
check "bun" bun --version
check "claude" claude --version
check "codex" codex --version
check "sudo" sudo --version
report_results
