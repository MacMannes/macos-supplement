#!/bin/bash

# Load shared colors and functions
source ./colors.sh
source ./functions.sh

log "Installing Homebrew..." step

LOGFILE="brew-install.log"
DRY_RUN=0

# -----------------------------
# Parse arguments
# -----------------------------
for arg in "$@"; do
    case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    *) log "Unknown argument: $arg" warn ;;
    esac
done

# -----------------------------
# Check and install Homebrew
# -----------------------------
if ! command -v brew &>/dev/null; then
    log "Homebrew is not installed. Installing..." info
    run /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ $DRY_RUN -eq 0 ]] && ! command -v brew &>/dev/null; then
        log "Homebrew installation failed." error
        exit 1
    fi
    log "Homebrew installed successfully." success
else
    log "Homebrew is already installed." warning
    run brew update
fi
