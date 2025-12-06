#!/bin/bash

source ./colors.sh
source ./functions.sh

CACHE_FILE="./cache/selected_profiles.txt"

if [[ ! -f "$CACHE_FILE" ]]; then
    warn "No profiles selected. Run select-profiles.sh first."
    exit 1
fi

read -a SELECTED_PROFILES <"$CACHE_FILE"

step "Installing selected profiles"

for PROFILE in "${SELECTED_PROFILES[@]}"; do
    msg "Processing profile: ${PROFILE}"

    PROFILE_DIR="./profiles/${PROFILE}"

    if [[ ! -d "$PROFILE_DIR" ]]; then
        warn "Profile directory missing: $PROFILE_DIR"
        continue
    fi

    # 1) Install Brewfile if present
    if [[ -f "${PROFILE_DIR}/Brewfile" ]]; then
        msg "Applying Brewfile"
        run brew bundle --file "${PROFILE_DIR}/Brewfile"
    else
        msg "No Brewfile found (skipping)"
    fi

    # 2) Run install.sh if present
    if [[ -f "${PROFILE_DIR}/install.sh" ]]; then
        msg "Running install.sh"
        cd "${PROFILE_DIR}" || exit 1
        run bash "./install.sh"
        cd "${ROOT_DIR}" || exit 1
    else
        msg "No install.sh found (skipping)"
    fi

done

done_step
