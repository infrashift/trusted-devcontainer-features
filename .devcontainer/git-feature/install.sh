#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# git-feature/install.sh
# Licensed under the MIT License.
#-------------------------------------------------------------------------------------------------------------
#
# Docs: 
# Maintainer: infrashift.sh
#
# Notes: This is the feature activation entrypoint script; It is ALWAYS executed as the 'root' user.
set -e

echo "                                                                                "
echo "********************************************************************************"
echo "BEGIN FEATURE ACTIVATION                                                        "
echo "Activating feature 'Git'...                                                     "
echo "********************************************************************************"
echo "                                                                                "

#
# These environment variables are passed in by the devcontainer CLI.
# For more details, see https://containers.dev/implementors/features#user-env-var
echo "The effective DevContainer remoteUser is '${_REMOTE_USER}'"
echo "The effective DevContainer remoteUser's home directory is '${_REMOTE_USER_HOME}'"

echo "The effective DevContainer containerUser is '${_CONTAINER_USER}'"
echo "The effective DevContainer containerUser's home directory is '${_CONTAINER_USER_HOME}'"

echo "The effective DevContainer Feature user is '${FEATURE_BOOTSTRAP_USERNAME}'"
echo "The effective DevContainer Feature user UID is '${FEATURE_BOOTSTRAP_USER_UID}'"
echo "The effective DevContainer Feature user GID is '${FEATURE_BOOTSTRAP_USER_GID}'"
echo "The effective DevContainer Feature user home is '${FEATURE_BOOTSTRAP_USER_HOME}'"

# List feature install assets
echo "Listing DevContainer Feature activation assets..."
ls -al .
echo ""

# Change ownership of feature install assets
echo "Changing ownership of feature activation assets..."
chown -R ${FEATURE_BOOTSTRAP_USERNAME}:${FEATURE_BOOTSTRAP_USERNAME} .
echo ""

# Execute ansible-inventory as the Secure DevContainer Feature user
# This will showcase issues with the inventory before making use of the inventory to run the activate-feature playbook
echo "Parsing Ansible Inventory for host 'localhost'..."
su -s /bin/bash ${FEATURE_BOOTSTRAP_USERNAME} <<EOF
    ${FEATURE_BOOTSTRAP_USER_LOCAL_BIN_PATH}/ansible-inventory --inventory ${FEATURE_BOOTSTRAP_USER_HOME}/hosts.yml --host localhost --yaml
EOF
echo ""

# Execute ansible-playbook as the Secure DevContainer Feature user
echo "Activating DevContainer Feature..."
su -s /bin/bash ${FEATURE_BOOTSTRAP_USERNAME} <<EOF
    ${FEATURE_BOOTSTRAP_USER_LOCAL_BIN_PATH}/ansible-playbook --inventory ${FEATURE_BOOTSTRAP_USER_HOME}/hosts.yml activate-feature.yml
EOF
echo ""

echo "                                                                                "
echo "********************************************************************************"
echo "END FEATURE ACTIVATION                                                          "
echo "********************************************************************************"
echo "                                                                                "
