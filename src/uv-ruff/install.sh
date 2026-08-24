#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# uv-ruff-feature/install.sh
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
: "${TARGET_UV_VERSION:?feature option 'target_uv_version' resolved empty — devcontainer-feature.json must declare a default}"
: "${TARGET_RUFF_VERSION:?feature option 'target_ruff_version' resolved empty — devcontainer-feature.json must declare a default}"

exec /opt/bootstrap/run-feature.sh \
    --role ansible-role-feature \
    -e "_uv_version=${TARGET_UV_VERSION}" \
    -e "_uv_checksum=${TARGET_UV_CHECKSUM:-}" \
    -e "_ruff_version=${TARGET_RUFF_VERSION}"
