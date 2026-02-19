#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# uv-ruff-feature/install.sh
# Licensed under the MIT License.
#-------------------------------------------------------------------------------------------------------------
#
# Maintainer: infrashift.sh
#
# This is the feature activation entrypoint script; it is ALWAYS executed as the 'root' user.
# See https://containers.dev/implementors/features/#user-env-var for devcontainer CLI variables.
set -e

echo "                                                                                "
echo "********************************************************************************"
echo "BEGIN FEATURE ACTIVATION                                                        "
echo "Activating feature 'UV + Ruff'...                                               "
echo "********************************************************************************"
echo "                                                                                "

echo "The effective DevContainer remoteUser is '${_REMOTE_USER}'"
echo "The effective DevContainer remoteUser's home directory is '${_REMOTE_USER_HOME}'"
echo "The effective DevContainer containerUser is '${_CONTAINER_USER}'"
echo "The effective DevContainer containerUser's home directory is '${_CONTAINER_USER_HOME}'"

ls -al .

# Prevent root-owned caches in dev user home during feature install
export UV_CACHE_DIR=/tmp/uv-feature-cache
export ANSIBLE_LOCAL_TMP=/tmp/ansible-feature-tmp

# Verify uv is available (provided by the base Containerfile)
if ! command -v uv &> /dev/null; then
    echo "ERROR: uv is not installed. It should be provided by the base Containerfile."
    exit 1
fi
echo "uv version: $(uv --version)"

# Validate Ansible inventory
echo "Parsing Ansible Inventory for host 'localhost'..."
uv run --with ansible-core ansible-inventory --inventory ./hosts.yml --host localhost --yaml

# Execute ansible-playbook as root
# TARGET_UV_VERSION, TARGET_UV_CHECKSUM, TARGET_RUFF_VERSION are defined in devcontainer-feature.json
echo "Activating DevContainer Feature..."
uv run --with ansible-core ansible-playbook \
    --inventory ./hosts.yml \
    activate-feature.yml \
    -e "remote_user=${_REMOTE_USER}" \
    -e "remote_user_home=${_REMOTE_USER_HOME}" \
    -e "uv_version=${TARGET_UV_VERSION}" \
    -e "uv_checksum=${TARGET_UV_CHECKSUM}" \
    -e "ruff_version=${TARGET_RUFF_VERSION}"

echo "                                                                                "
echo "********************************************************************************"
echo "END FEATURE ACTIVATION                                                          "
echo "********************************************************************************"
echo "                                                                                "
