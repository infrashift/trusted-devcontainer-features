#!/usr/bin/env bash
set -euo pipefail
_PASS=0; _FAIL=0; _FAILURES=""
check() {
    local label="$1"; shift
    echo -n "  TEST: ${label}... "
    if output=$("$@" 2>&1); then echo "PASS"; _PASS=$((_PASS+1))
    else echo "FAIL"; echo "    Output: ${output}"; _FAIL=$((_FAIL+1)); _FAILURES="${_FAILURES}\n  - ${label}"; fi
}
report_results() {
    echo ""; echo "Results: ${_PASS}/$((_PASS+_FAIL)) passed, ${_FAIL} failed"
    [ "${_FAIL}" -gt 0 ] && { echo -e "Failures:${_FAILURES}"; exit 1; }; exit 0
}
