#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# envbuilder-feature/install.sh
# Licensed under the MIT License.
#-------------------------------------------------------------------------------------------------------------
#
# Maintainer: infrashift.sh
#
# Thin wrapper. All installation logic lives in ansible-role-feature/.
# The shared runner is provided by the 'bootstrap' feature (see dependsOn).
#
# Userland lane: envbuilder is a single static binary that lands under the
# user's home, so nothing here needs --privileged.
set -euo pipefail

# Fail in the shell when a mandatory option resolves empty. The role's assert
# cannot tell "unset" from "empty string", and an empty version silently builds
# a lookup that misses the pinned map.
: "${TARGET_VERSION:?feature option 'target_version' resolved empty — devcontainer-feature.json must declare a default}"

# target_checksum is legitimately empty: empty means "use the pinned map".
# Only absence is a bug, so it uses :- rather than :?.
exec /opt/bootstrap/run-feature.sh \
    --role ansible-role-feature \
    -e "_envbuilder_version=${TARGET_VERSION}" \
    -e "_envbuilder_checksum=${TARGET_CHECKSUM:-}"
