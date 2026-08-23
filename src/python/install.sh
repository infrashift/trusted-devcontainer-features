#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# python-feature/install.sh
# Licensed under the MIT License.
#-------------------------------------------------------------------------------------------------------------
#
# Maintainer: infrashift.sh
#
# Thin wrapper. All installation logic lives in ansible-role-feature/.
# The shared runner is provided by the 'bootstrap' feature (see dependsOn).
set -euo pipefail

# Fail in the shell when a mandatory option resolves empty: the role's assert
# cannot tell "unset" from "empty string", and an empty version silently builds
# a malformed install command. Never add a `:-fallback` here — that would
# reintroduce the second source of truth this design removes.
: "${TARGET_VERSION:?feature option 'target_version' resolved empty — devcontainer-feature.json must declare a default}"

exec /opt/bootstrap/run-feature.sh \
    --role ansible-role-feature \
    -e "_python_version=${TARGET_VERSION}"
