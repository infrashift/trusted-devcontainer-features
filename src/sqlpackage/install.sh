#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# sqlpackage-feature/install.sh
# Licensed under the MIT License.
#-------------------------------------------------------------------------------------------------------------
#
# Maintainer: infrashift.sh
#
# Thin wrapper. All installation logic lives in ansible-role-feature/.
# The shared runner is provided by the 'bootstrap' feature (see dependsOn).
#
# NOT --privileged. SqlPackage is a .NET tool installed into the target user's
# home; nothing here mutates system state.
set -euo pipefail

# Fail in the shell when a mandatory option resolves empty. This is the earliest
# and clearest failure point: the role's assert cannot tell "unset" from "empty
# string", and an empty version makes `dotnet tool install` resolve the latest
# release instead of the pinned one — which succeeds, and is the wrong build.
#
# Never add a `:-fallback` for a mandatory option — that reintroduces the second
# source of truth this design removes, and shadows the default in
# devcontainer-feature.json rather than surfacing that it went missing.
: "${TARGET_VERSION:?feature option 'target_version' resolved empty — devcontainer-feature.json must declare a default}"

exec /opt/bootstrap/run-feature.sh \
    --role ansible-role-feature \
    -e "_sqlpackage_version=${TARGET_VERSION}"
