#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# scripts/prepare-devcontainer.sh
# Licensed under the MIT License.
#-------------------------------------------------------------------------------------------------------------
#
# Stages this repo's features into .devcontainer/ so the maintainer environment
# can be built from the working tree.
#
# The devcontainer CLI requires a local feature path to be a child of the folder
# holding devcontainer.json:
#
#   Local file path parse error. Resolved path must be a child of the
#   .devcontainer/ folder.  Parsed: .../devcontainer-features/src/git
#
# so "../src/<id>" can never resolve. This is the same staging step that
# `make test-template` and CI's "Prepare test template" perform for the test
# templates; devcontainer.json runs it via initializeCommand, which the CLI
# executes on the host before it resolves features.
#
# The staged copies are gitignored. SKELETON-feature is NOT a staged copy -- it
# is tracked source and must survive.
#
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

# Drop previously staged features first, so a feature deleted from src/ does not
# linger here and keep resolving.
for d in .devcontainer/*/; do
    [ -d "$d" ] || continue
    case "$d" in
        .devcontainer/SKELETON-feature/) continue ;;
    esac
    rm -rf "$d"
done

cp -r src/* .devcontainer/
echo "Staged $(find src -maxdepth 1 -mindepth 1 -type d | wc -l) features into .devcontainer/"
