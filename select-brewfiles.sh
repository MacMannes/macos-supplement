#!/bin/bash

source ./colors.sh
source ./functions.sh

CACHE_DIR="./cache"
mkdir -p "$CACHE_DIR"
CACHE_FILE="$CACHE_DIR/last_profiles.txt"

AVAILABLE_PROFILES=("core" "dev" "personal")

# Load last selection (Bash 3 compatible)
DEFAULT_SELECTION=()
if [[ -f "$CACHE_FILE" ]]; then
    while IFS= read -r line || [[ -n "$line" ]]; do
        DEFAULT_SELECTION+=("$line")
    done <"$CACHE_FILE"
fi

# Ask user for selection
SELECTED=$(printf "%s\n" "${AVAILABLE_PROFILES[@]}" |
    gum choose --no-limit --header "Select Brewfile profiles" --selected="$(printf "%s\n" "${DEFAULT_SELECTION[@]}")")

# Convert selected string to array
SELECTED_PROFILES=()
while IFS= read -r line || [[ -n "$line" ]]; do
    SELECTED_PROFILES+=("$line")
done <<<"$SELECTED"

# Save selection to file
printf "%s\n" "${SELECTED_PROFILES[@]}" >"$CACHE_DIR/selected_profiles.txt"
