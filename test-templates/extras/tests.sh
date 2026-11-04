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
check "okfw is the pinned release" bash -c 'okfw --version | grep -qx "okfw version v2026\.10\.2"'
# The MCP server is the same binary; it must answer the handshake on stdio.
check "okfw mcp answers initialize" bash -c \
    'echo '"'"'{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"tests","version":"1"}}}'"'"' \
     | (cd /tmp && timeout 15 okfw mcp) | grep -q "\"result\""'
report_results
