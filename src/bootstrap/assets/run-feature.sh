#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# bootstrap-feature/assets/run-feature.sh -> /opt/bootstrap/run-feature.sh
# Licensed under the MIT License.
#-------------------------------------------------------------------------------------------------------------
#
# The shared entrypoint for every trusted devcontainer feature. A feature's
# install.sh is expected to be a thin wrapper around this script.
#
# Usage:
#   run-feature.sh --role <role-dir> [--privileged] [-e key=value]...
#
# Two lanes:
#   default       drops from root to the target user via setpriv. Files land
#                 correctly owned by construction, so no chown repair is needed.
#   --privileged  stays root. Only for features that mutate system state.
#
set -euo pipefail

BOOTSTRAP_DIR=/opt/bootstrap
VENV_DIR="${BOOTSTRAP_DIR}/.bootstrap"
ANSIBLE_PLAYBOOK="${VENV_DIR}/bin/ansible-playbook"
PLAYBOOK="${BOOTSTRAP_DIR}/site.yml"
INVENTORY="${BOOTSTRAP_DIR}/inventory.yml"

ROLE=""
PRIVILEGED=0
EXTRA_VARS=()

while [ $# -gt 0 ]; do
    case "$1" in
        --role)       ROLE="$2"; shift 2 ;;
        --privileged) PRIVILEGED=1; shift ;;
        -e)           EXTRA_VARS+=("$2"); shift 2 ;;
        *) echo "ERROR: unknown argument '$1'" >&2; exit 1 ;;
    esac
done

[ -n "${ROLE}" ] || { echo "ERROR: --role is required" >&2; exit 1; }

# Hard-fail rather than silently falling back to an unpinned 'uv run'. If the
# bootstrap feature is missing, that is a configuration error worth surfacing.
if [ ! -x "${ANSIBLE_PLAYBOOK}" ]; then
    echo "ERROR: ${ANSIBLE_PLAYBOOK} not found." >&2
    echo "The 'bootstrap' feature must be installed first. Every trusted feature" >&2
    echo "declares dependsOn it, so this usually means a hand-edited devcontainer.json." >&2
    exit 1
fi

TARGET_USER="${_REMOTE_USER:-}"
TARGET_HOME="${_REMOTE_USER_HOME:-}"
if [ -z "${TARGET_USER}" ] || [ -z "${TARGET_HOME}" ]; then
    echo "ERROR: _REMOTE_USER / _REMOTE_USER_HOME are not set." >&2
    echo "These are provided by the devcontainer CLI; there is no safe default." >&2
    exit 1
fi

case "$(uname -m)" in
    x86_64)  TARGET_ARCH="amd64" ;;
    aarch64) TARGET_ARCH="arm64" ;;
    *) echo "ERROR: unsupported architecture '$(uname -m)'" >&2; exit 1 ;;
esac

# Roles are vendored inside each feature directory, and the devcontainer CLI
# runs install.sh from that directory.
ROLES_PATH="$(pwd)"

# Keep Ansible's scratch state out of the developer's home. All three are needed:
# ANSIBLE_HOME alone still leaves remote_tmp defaulting to ~/.ansible/tmp.
ANSIBLE_HOME_DIR=/tmp/ansible-bootstrap
ANSIBLE_TMP_DIR="${ANSIBLE_HOME_DIR}/tmp"
mkdir -p "${ANSIBLE_TMP_DIR}"

CMD=(
    "${ANSIBLE_PLAYBOOK}"
    --inventory "${INVENTORY}"
    "${PLAYBOOK}"
    -e "feature_role=${ROLE}"
    -e "_target_username=${TARGET_USER}"
    -e "_target_user_home=${TARGET_HOME}"
    -e "_target_arch=${TARGET_ARCH}"
)
for kv in ${EXTRA_VARS+"${EXTRA_VARS[@]}"}; do
    CMD+=(-e "${kv}")
done

echo "Feature role   : ${ROLE}"
echo "Target user    : ${TARGET_USER} (${TARGET_HOME})"
echo "Target arch    : ${TARGET_ARCH}"
echo "Lane           : $([ "${PRIVILEGED}" -eq 1 ] && echo privileged || echo userland)"

if [ "${PRIVILEGED}" -eq 1 ]; then
    export ANSIBLE_ROLES_PATH="${ROLES_PATH}"
    export ANSIBLE_HOME="${ANSIBLE_HOME_DIR}"
    export ANSIBLE_REMOTE_TMP="${ANSIBLE_TMP_DIR}"
    export ANSIBLE_LOCAL_TEMP="${ANSIBLE_TMP_DIR}"
    exec "${CMD[@]}"
fi

# Userland lane.
#
# setpriv, not runuser/su: those go through PAM, which needs privileges the
# container build does not have ("failed to establish user credentials"). setpriv
# performs a plain setuid/setgid with no PAM involvement.
#
# It also does not propagate the environment the way a login shell would, so pass
# everything Ansible needs explicitly.
chown -R "${TARGET_USER}" "${ANSIBLE_HOME_DIR}"
exec setpriv --reuid="${TARGET_USER}" --regid="${TARGET_USER}" --init-groups -- env \
    HOME="${TARGET_HOME}" \
    PATH="${TARGET_HOME}/.local/bin:/usr/local/bin:/usr/bin:/bin" \
    ANSIBLE_ROLES_PATH="${ROLES_PATH}" \
    ANSIBLE_HOME="${ANSIBLE_HOME_DIR}" \
    ANSIBLE_REMOTE_TMP="${ANSIBLE_TMP_DIR}" \
    ANSIBLE_LOCAL_TEMP="${ANSIBLE_TMP_DIR}" \
    "${CMD[@]}"
