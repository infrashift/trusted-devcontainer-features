#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# jq-feature/install.sh
# Licensed under the MIT License.
#-------------------------------------------------------------------------------------------------------------
#
# Maintainer: infrashift.sh
#
# Thin wrapper. All installation logic lives in ansible-role-feature/.
# The shared runner is provided by the 'bootstrap' feature (see dependsOn).
set -euo pipefail

# Fail in the shell when a mandatory option resolves empty. This is the earliest
# and clearest failure point: the role's assert cannot tell "unset" from "empty
# string", and an empty value silently builds a malformed URL or command.
#
# Never add a `:-fallback` for a mandatory option — that reintroduces the second
# source of truth this design removes, and shadows the default in
# devcontainer-feature.json rather than surfacing that it went missing.
#
# The *_CHECKSUM options are legitimately empty (empty means "resolve from the
# pinned map or the upstream checksums file"), so they keep :- rather than :?.
: "${TARGET_VERSION:?feature option 'target_version' resolved empty — devcontainer-feature.json must declare a default}"

exec /opt/bootstrap/run-feature.sh \
    --role ansible-role-feature \
    -e "_jq_version=${TARGET_VERSION}" \
    -e "_jq_checksum=${TARGET_CHECKSUM:-}"
