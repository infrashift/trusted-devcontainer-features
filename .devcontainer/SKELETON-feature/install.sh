#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# SKELETON-feature/install.sh
# Licensed under the MIT License.
#-------------------------------------------------------------------------------------------------------------
#
# Maintainer: infrashift.sh
#
# Thin wrapper — this is the whole script. All installation logic belongs in
# ansible-role-feature/tasks/main.sh. Do not add imperative shell here.
#
# The devcontainer CLI always runs this as root. /opt/bootstrap/run-feature.sh
# then drops to the target user (the userland lane) before running Ansible, so
# roles never need become/become_user.
#
# Add --privileged ONLY if the role genuinely mutates system state (packages,
# /etc, sudoers). Everything installed into the user's home must stay userland.
#
# Role variables are passed with their role-internal underscore names. The role
# has NO defaults, so every value it needs must appear below — a missing -e is
# a wiring bug, caught by the PARAMETER BRACKET in tasks/main.yml.
set -euo pipefail

# Fail here, in the shell, when a mandatory option resolves empty. This is the
# earliest and clearest failure point: the role's assert cannot tell "unset"
# from "empty string", and an empty version silently builds a malformed URL.
#
# Never add a `:-fallback` for a mandatory option. That reintroduces the second
# source of truth this design exists to remove, and it shadows the default in
# devcontainer-feature.json rather than surfacing that it went missing.
: "${TARGET_VERSION:?feature option 'target_version' resolved empty — devcontainer-feature.json must declare a default}"
: "${COLOR_CHOICE:?feature option 'color_choice' resolved empty — devcontainer-feature.json must declare a default}"
: "${IS_MY_FAVORITE_COLOR:?feature option 'is_my_favorite_color' resolved empty — devcontainer-feature.json must declare a default}"

# target_checksum is legitimately empty: empty means "use the pinned map".
# Only absence is a bug, so it uses :- rather than :?.
exec /opt/bootstrap/run-feature.sh \
    --role ansible-role-feature \
    -e "_skeleton_version=${TARGET_VERSION}" \
    -e "_skeleton_checksum=${TARGET_CHECKSUM:-}" \
    -e "_color=${COLOR_CHOICE}" \
    -e "_is_favorite_color=${IS_MY_FAVORITE_COLOR}"
