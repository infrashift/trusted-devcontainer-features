#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# bootstrap-feature/install.sh
# Licensed under the MIT License.
#-------------------------------------------------------------------------------------------------------------
#
# Maintainer: infrashift.sh
#
# This is the feature activation entrypoint script; it is ALWAYS executed as the 'root' user.
#
# This feature is deliberately PLAIN BASH. It cannot use Ansible, because it is
# what creates the Ansible environment every other feature runs from.
#
# It provisions:
#   /usr/local/bin/uv                     pinned, checksum-verified
#   /opt/bootstrap/python/                uv-managed CPython (world-readable, NOT under /root)
#   /opt/bootstrap/.bootstrap/            venv with pinned ansible-core
#   /opt/bootstrap/inventory.yml          variant detected once, from /etc/os-release
#   /opt/bootstrap/site.yml               generic playbook that applies one role
#   /opt/bootstrap/run-feature.sh         the shared entrypoint every other feature execs
#
set -euo pipefail

# No `:-fallback` here by design. devcontainer-feature.json declares a default
# for each of these options and the devcontainer CLI always materializes it, so
# a fallback could only ever shadow that default -- and mask the fact that it
# went missing. Fail loudly instead.
: "${UV_VERSION:?feature option 'uv_version' resolved empty — devcontainer-feature.json must declare a default}"
: "${PYTHON_VERSION:?feature option 'python_version' resolved empty — devcontainer-feature.json must declare a default}"
: "${ANSIBLE_CORE_VERSION:?feature option 'ansible_core_version' resolved empty — devcontainer-feature.json must declare a default}"

BOOTSTRAP_DIR=/opt/bootstrap
VENV_DIR="${BOOTSTRAP_DIR}/.bootstrap"

echo "********************************************************************************"
echo "BEGIN FEATURE ACTIVATION - bootstrap"
echo "  uv            ${UV_VERSION}"
echo "  python        ${PYTHON_VERSION}"
echo "  ansible-core  ${ANSIBLE_CORE_VERSION}"
echo "********************************************************************************"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ---------------------------------------------------------------------------
# Resolve target architecture
# ---------------------------------------------------------------------------
case "$(uname -m)" in
    x86_64)  UV_TRIPLE="x86_64-unknown-linux-gnu" ;;
    aarch64) UV_TRIPLE="aarch64-unknown-linux-gnu" ;;
    *) echo "ERROR: unsupported architecture '$(uname -m)'" >&2; exit 1 ;;
esac

# Checksums pinned for the DEFAULT uv version. If the version is overridden we
# fall back to the checksum file published alongside that release.
declare -A PINNED_SHA256=(
    ["0.12.5:x86_64-unknown-linux-gnu"]="68a509da24b06b4223a1c0175fb5eb5bc79342b76cbeff0cfe51ac3f5b17b6b2"
    ["0.12.5:aarch64-unknown-linux-gnu"]="9bf43b4d1a07665bf64d4c4e710930b382321a785e0eb10aac07f46471f86a31"
)

# ---------------------------------------------------------------------------
# Install uv (pinned + checksum verified)
# ---------------------------------------------------------------------------
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

TARBALL="uv-${UV_TRIPLE}.tar.gz"
BASE_URL="https://github.com/astral-sh/uv/releases/download/${UV_VERSION}"

echo "Downloading ${TARBALL} ..."
curl -fsSL -o "${TMP_DIR}/${TARBALL}" "${BASE_URL}/${TARBALL}"

EXPECTED="${PINNED_SHA256[${UV_VERSION}:${UV_TRIPLE}]:-}"
if [ -z "${EXPECTED}" ]; then
    echo "uv ${UV_VERSION} is not the pinned default; fetching its published checksum."
    EXPECTED="$(curl -fsSL "${BASE_URL}/${TARBALL}.sha256" | awk '{print $1}')"
fi
[ -n "${EXPECTED}" ] || { echo "ERROR: no checksum available for uv ${UV_VERSION}" >&2; exit 1; }

ACTUAL="$(sha256sum "${TMP_DIR}/${TARBALL}" | awk '{print $1}')"
if [ "${ACTUAL}" != "${EXPECTED}" ]; then
    echo "ERROR: checksum mismatch for ${TARBALL}" >&2
    echo "  expected ${EXPECTED}" >&2
    echo "  actual   ${ACTUAL}" >&2
    exit 1
fi
echo "Checksum verified: ${ACTUAL}"

tar -xzf "${TMP_DIR}/${TARBALL}" -C "${TMP_DIR}" --strip-components=1
install -m 0755 "${TMP_DIR}/uv" /usr/local/bin/uv
install -m 0755 "${TMP_DIR}/uvx" /usr/local/bin/uvx
echo "uv installed: $(uv --version)"

# ---------------------------------------------------------------------------
# Build the .bootstrap environment
#
# UV_PYTHON_INSTALL_DIR matters: uv's default is ~/.local/share/uv/python, which
# for root is under /root (mode 0700). The venv interpreter would then be
# unreadable by the unprivileged user that actually runs the playbooks.
# ---------------------------------------------------------------------------
export UV_PYTHON_INSTALL_DIR="${BOOTSTRAP_DIR}/python"
export UV_CACHE_DIR=/tmp/uv-bootstrap-cache

mkdir -p "${BOOTSTRAP_DIR}"

echo "Creating ${VENV_DIR} on Python ${PYTHON_VERSION} ..."
uv venv --python "${PYTHON_VERSION}" "${VENV_DIR}"

echo "Installing ansible-core==${ANSIBLE_CORE_VERSION} ..."
uv pip install --python "${VENV_DIR}/bin/python" "ansible-core==${ANSIBLE_CORE_VERSION}"

# ---------------------------------------------------------------------------
# Detect the devcontainer variant ONCE, here, from the real OS.
#
# Previously every feature shipped a hosts.yml that hardcoded localhost into the
# 'ubi9' group, so the compatibility assert at the top of each role compared
# "ubi9" against ["ubi9","ubi10"] and passed regardless of the actual base image.
# ---------------------------------------------------------------------------
# shellcheck disable=SC1091
. /etc/os-release
OS_MAJOR="${VERSION_ID%%.*}"
case "${ID}" in
    rhel)   VARIANT="ubi${OS_MAJOR}" ;;   # UBI images report ID=rhel
    fedora) VARIANT="fedora${OS_MAJOR}" ;;
    *)      VARIANT="${ID}${OS_MAJOR}" ;;
esac
echo "Detected devcontainer variant: ${VARIANT} (ID=${ID}, VERSION_ID=${VERSION_ID})"

cat > "${BOOTSTRAP_DIR}/inventory.yml" <<INVENTORY
# Generated by the bootstrap feature at image build time. Do not edit.
---
all:
  children:
    devcontainer:
      hosts:
        localhost:
          ansible_connection: local
          ansible_python_interpreter: ${VENV_DIR}/bin/python
      vars:
        _securedevcontainer_variant: "${VARIANT}"
...
INVENTORY

install -m 0644 "${SCRIPT_DIR}/assets/site.yml" "${BOOTSTRAP_DIR}/site.yml"
install -m 0755 "${SCRIPT_DIR}/assets/run-feature.sh" "${BOOTSTRAP_DIR}/run-feature.sh"
install -d -m 0755 "${BOOTSTRAP_DIR}/tasks"
install -m 0644 "${SCRIPT_DIR}/assets/tasks/install-packages.yml" "${BOOTSTRAP_DIR}/tasks/install-packages.yml"

# ---------------------------------------------------------------------------
# Lock it down: root-owned, world readable/executable, not writable by the
# developer. The dev user runs this toolchain but cannot tamper with it.
# ---------------------------------------------------------------------------
chown -R root:root "${BOOTSTRAP_DIR}"
chmod -R a+rX "${BOOTSTRAP_DIR}"
rm -rf "${UV_CACHE_DIR}"

# The base image sets ENV HOME=/home/<user>, so a bare ansible invocation here
# would run as root but create a ROOT-OWNED /home/<user>/.ansible that the
# unprivileged user can no longer write to. Verify against a throwaway HOME.
echo "Verifying bootstrap environment ..."
VERIFY_HOME="$(mktemp -d)"
env HOME="${VERIFY_HOME}" ANSIBLE_HOME="${VERIFY_HOME}" \
    "${VENV_DIR}/bin/ansible-playbook" --version
env HOME="${VERIFY_HOME}" ANSIBLE_HOME="${VERIFY_HOME}" \
    "${VENV_DIR}/bin/ansible-inventory" --inventory "${BOOTSTRAP_DIR}/inventory.yml" --host localhost --yaml
rm -rf "${VERIFY_HOME}"

# Belt and braces: if anything upstream already created a root-owned .ansible in
# the target home, hand it back to the user it belongs to.
if [ -n "${_REMOTE_USER:-}" ] && [ -d "${_REMOTE_USER_HOME:-/nonexistent}/.ansible" ]; then
    chown -R "${_REMOTE_USER}" "${_REMOTE_USER_HOME}/.ansible"
fi

echo "********************************************************************************"
echo "END FEATURE ACTIVATION - bootstrap"
echo "********************************************************************************"
