#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# sudo-feature/install.sh
# Licensed under the MIT License.
#-------------------------------------------------------------------------------------------------------------
#
# Maintainer: infrashift.sh
#
# Thin wrapper. All installation logic lives in ansible-role-feature/.
# The shared runner is provided by the 'bootstrap' feature (see dependsOn).
#
# --privileged: this feature mutates system state (packages, /etc), so the
# runner keeps it as root instead of dropping to the target user.
set -euo pipefail

exec /opt/bootstrap/run-feature.sh \
    --role ansible-role-feature \
    --privileged
