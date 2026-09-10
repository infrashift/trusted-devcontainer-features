#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# sshd-feature/install.sh
# Licensed under the MIT License.
#-------------------------------------------------------------------------------------------------------------
#
# Maintainer: infrashift.sh
#
# Thin wrapper. All installation logic lives in ansible-role-feature/.
# The shared runner is provided by the 'bootstrap' feature (see dependsOn).
#
# --privileged: installs a system RPM and writes /etc/ssh, so the runner keeps
# this as root instead of dropping to the target user. Only git, git-lfs and
# this feature use that lane.
set -euo pipefail

# Fail in the shell when a mandatory option resolves empty. Neither of these has
# a safe fallback: an empty port yields a config sshd refuses to load, and an
# empty keys path would silently authorize nothing.
: "${SSHD_PORT:?feature option 'sshd_port' resolved empty — devcontainer-feature.json must declare a default}"
: "${AUTHORIZED_KEYS_PATH:?feature option 'authorized_keys_path' resolved empty — devcontainer-feature.json must declare a default}"

exec /opt/bootstrap/run-feature.sh \
    --role ansible-role-feature \
    --privileged \
    -e "_sshd_port=${SSHD_PORT}" \
    -e "_sshd_authorized_keys_path=${AUTHORIZED_KEYS_PATH}"
