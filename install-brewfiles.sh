#!/bin/bash

source ./colors.sh
source ./functions.sh

CACHE_FILE="./cache/selected_profiles.txt"

if [[ ! -f "$CACHE_FILE" ]]; then
    warn "No profiles selected. Run select-brewfiles.sh first."
    exit 1
fi

read -a SELECTED_PROFILES <"$CACHE_FILE"

step "Installing selected Brewfiles"

for PROFILE in "${SELECTED_PROFILES[@]}"; do
    BREWFILE="./Brewfiles/Brewfile-${PROFILE}"
    if [[ -f "$BREWFILE" ]]; then
        msg "Applying Brewfile: $BREWFILE"
        run brew bundle --file "$BREWFILE"
    else
        warn "Brewfile not found: $BREWFILE"
    fi
done

done_step
