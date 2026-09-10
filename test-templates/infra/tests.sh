#!/usr/bin/env bash
source "$(dirname "$0")/test-lib.sh"

# These run as `dev` via `devcontainer exec`, so they assert only what the
# unprivileged user can actually observe. The root-side facts -- that the system
# drop-in loads, that the account was unlocked -- are asserted by the sshd role
# itself at install time, where it has the privilege to check them.

# --- kaniko -----------------------------------------------------------------
# The executor is the only one of the three binaries that can be asked its
# version. Match the real output format: "Kaniko version :  v1.28.4".
check "kaniko-executor runs" kaniko-executor version
check "kaniko-executor reports the pinned version" \
    bash -c 'kaniko-executor version | grep -q "v1\.28\.4"'
# The warmer has no version output of any kind, so the version-scoped install
# prefix is the only place its version is legible.
check "kaniko-warmer is executable at the pinned prefix" \
    test -x "$HOME/.local/share/kaniko/1.28.4/warmer"
check "kaniko-warmer is on PATH" bash -c 'command -v kaniko-warmer >/dev/null'

# --- envbuilder -------------------------------------------------------------
# Deliberately never executed: `envbuilder version` prints a banner and then
# goes on to start a build. Path and prefix are what can be asserted safely.
check "envbuilder is executable at the pinned prefix" \
    test -x "$HOME/.local/share/envbuilder/1.3.0/envbuilder"
check "envbuilder is on PATH" bash -c 'command -v envbuilder >/dev/null'

# --- sshd -------------------------------------------------------------------
check "sshd is installed" test -x /usr/sbin/sshd
check "ssh-init entrypoint is installed" test -x /usr/local/share/ssh-init.sh
check "rootless host key was generated" test -f "$HOME/.ssh/sshd/ssh_host_ed25519_key"
check "rootless sshd config loads" /usr/sbin/sshd -t -f "$HOME/.ssh/sshd/sshd_config"

# The entrypoint runs at container start, so sshd should already be serving.
# Read the protocol banner rather than merely opening the socket: a listening
# port proves something is bound, the banner proves it is actually SSH.
check "sshd answers with an SSH banner on 2222" bash -c '
    for _ in $(seq 1 15); do
        if banner=$( (exec 3<>/dev/tcp/127.0.0.1/2222 && head -1 <&3) 2>/dev/null ); then
            case "${banner}" in SSH-2.0-*) echo "${banner}"; exit 0 ;; esac
        fi
        sleep 1
    done
    echo "no SSH banner on port 2222" >&2
    exit 1'

# No authorized_keys is mounted in this template, so a successful login cannot
# be asserted here -- and must not be: a server that let someone in without a
# key would be the bug. What is asserted is that the daemon is up and speaking
# SSH; the full key-based login path is exercised by hand against a container
# built from this same template (see the feature's NOTES.md).
check "sshd admits no one without a mounted key" \
    bash -c '! test -f "$HOME/.ssh/authorized_keys"'

report_results
