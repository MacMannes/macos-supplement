#!/bin/bash

# Load shared colors and functions
source ./colors.sh
source ./functions.sh

log "Installing Homebrew packages..." step

PACKAGES_FILE="packages.txt"
LOGFILE="brew-install.log"
MODE="" # upgrade, reinstall, etc.
DRY_RUN=0

# -----------------------------
# Parse arguments
# -----------------------------
for arg in "$@"; do
    case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --upgrade) MODE="upgrade" ;;
    --reinstall) MODE="reinstall" ;;
    *) log "Unknown argument: $arg" warn ;;
    esac
done

# -----------------------------
# Brew helpers
# -----------------------------
tap_repo() {
    local tap="$1"
    if brew tap | grep -qx "$tap"; then
        log "Already tapped: $tap" tap
        return
    fi
    log "Tapping: $tap" tap
    run brew tap "$tap"
}

# -----------------------------
# Formula handlers
# -----------------------------
install_formula() {
    local pkg="$1"
    if brew list --formula | grep -qx "$pkg"; then
        log "Already installed (formula): $pkg" warn
        return
    fi
    log "Installing formula: $pkg" formula
    run brew install "$pkg"
}

upgrade_formula() {
    log "Upgrading formula: $1" formula
    run brew upgrade "$1"
}

reinstall_formula() {
    log "Reinstalling formula: $1" formula
    run brew reinstall "$1"
}

# -----------------------------
# Cask handlers
# -----------------------------
install_cask() {
    local pkg="$1"
    if brew list --cask | grep -qx "$pkg"; then
        log "Already installed (cask): $pkg" warn
        return
    fi
    log "Installing cask: $pkg" cask
    run brew install --cask "$pkg"
}

upgrade_cask() {
    log "Upgrading cask: $1" cask
    run brew upgrade --cask "$1"
}

reinstall_cask() {
    log "Reinstalling cask: $1" cask
    run brew reinstall --cask "$1"
}

# -----------------------------
# Dispatch table
# -----------------------------
dispatch() {
    local type="$1"
    local mode="$2"

    if [[ "$type" == "tap" ]]; then
        echo "tap_repo"
        return
    fi
    if [[ "$type" == "formula" ]]; then
        [[ "$mode" == "upgrade" ]] && echo "upgrade_formula" && return
        [[ "$mode" == "reinstall" ]] && echo "reinstall_formula" && return
        echo "install_formula"
        return
    fi
    if [[ "$type" == "cask" ]]; then
        [[ "$mode" == "upgrade" ]] && echo "upgrade_cask" && return
        [[ "$mode" == "reinstall" ]] && echo "reinstall_cask" && return
        echo "install_cask"
        return
    fi
}

# -----------------------------
# Process one line
# -----------------------------
process_entry() {
    local entry="$1"
    [[ -z "$entry" ]] && return
    [[ "$entry" =~ ^# ]] && return

    if [[ "$entry" == tap:* ]]; then
        local tap="${entry#tap:}"
        local action=$(dispatch "tap" "$MODE")
        $action "$tap"
        return
    fi

    if [[ "$entry" == cask:* ]]; then
        local pkg="${entry#cask:}"
        local action=$(dispatch "cask" "$MODE")
        $action "$pkg"
        return
    fi

    # default formula
    local pkg="$entry"
    local action=$(dispatch "formula" "$MODE")
    $action "$pkg"
}

# -----------------------------
# Main script
# -----------------------------

while IFS= read -r entry; do
    process_entry "$entry"
done <"$PACKAGES_FILE"
