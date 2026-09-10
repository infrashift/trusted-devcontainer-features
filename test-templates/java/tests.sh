#!/usr/bin/env bash
source "$(dirname "$0")/test-lib.sh"
check "java" java -version
check "mvn" mvn --version
check "mvn resolves to the pinned prefix" test -x "$HOME/.local/share/maven/apache-maven-3.9.16/bin/mvn"
check "gradle" gradle --version
check "gradle resolves to the pinned prefix" test -x "$HOME/.local/share/gradle/gradle-9.7.1/bin/gradle"
check "git" git --version
check "git-lfs" git-lfs --version
check "grype" grype version
check "syft" syft version
check "jq" jq --version
check "yq" yq --version
report_results
