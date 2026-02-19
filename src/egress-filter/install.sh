#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# egress-filter-feature/install.sh
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
echo "Activating feature 'Egress Filter'...                                           "
echo "********************************************************************************"
echo "                                                                                "

# Defensive programming: Fallback to 'vscode' if variables are empty during build
EFFECTIVE_USER="${_REMOTE_USER:-vscode}"
EFFECTIVE_HOME="${_REMOTE_USER_HOME:-/home/dev}"

echo "The effective DevContainer remoteUser is '${EFFECTIVE_USER}'"
echo "The effective DevContainer remoteUser's home directory is '${EFFECTIVE_HOME}'"
echo "The effective DevContainer containerUser is '${_CONTAINER_USER:-vscode}'"
echo "The effective DevContainer containerUser's home directory is '${_CONTAINER_USER_HOME:-/home/dev}'"

ls -al .

# Prevent root-owned caches in dev user home during feature install
export UV_CACHE_DIR=/tmp/uv-feature-cache
export ANSIBLE_HOME=/tmp/ansible-feature-home

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
echo "Activating DevContainer Feature for user ${EFFECTIVE_USER}..."
uv run --with ansible-core ansible-playbook \
    --inventory ./hosts.yml \
    activate-feature.yml \
    -e "remote_user=${EFFECTIVE_USER}" \
    -e "remote_user_home=${EFFECTIVE_HOME}" \
    -e "_target_username=${EFFECTIVE_USER}" \
    -e "_target_user_home=${EFFECTIVE_HOME}" \
    -e "_egress_allowed_domains=${ALLOWED_DOMAINS:-example.com}" \
    -e "_egress_squid_port=${SQUID_PORT:-3128}" \
    -e "_egress_allow_localhost=${ALLOW_LOCALHOST:-true}"

echo "                                                                                "
echo "********************************************************************************"
echo "END FEATURE ACTIVATION                                                          "
echo "********************************************************************************"
echo "                                                                                "
