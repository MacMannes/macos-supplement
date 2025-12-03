#!/bin/bash

# Load generic colors and functions
source ./colors.sh
source ./functions.sh

log "Installing dotfiles..." step

ORIGINAL_DIR=$(pwd)
REPO_URL="https://github.com/MacMannes/dotfiles.git"
REPO_NAME="dotfiles"
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
# Check stow
# -----------------------------
is_stow_installed() {
    which "stow" &>/dev/null
}

if ! is_stow_installed; then
    log "Install stow first" error
    exit 1
fi

cd ~

# -----------------------------
# Clone repository
# -----------------------------
if [ -d "$REPO_NAME" ]; then
    log "Repository '$REPO_NAME' already exists. Pulling latest changes..." info
    cd "$REPO_NAME" || {
        log "Failed to enter repository directory." error
        exit 1
    }

    if dry_run; then
        log "[DRY-RUN] git pull" info
    else
        if ! git pull; then
            log "Failed to pull latest changes from '$REPO_NAME'." error
            exit 1
        fi
        log "Repository '$REPO_NAME' updated successfully." success
    fi

    cd ~ || exit 1
else
    run git clone "$REPO_URL"
fi

# -----------------------------
# Remove old configs and stow
# -----------------------------
if [ -d "$REPO_NAME" ] || [[ $DRY_RUN -eq 1 ]]; then
    run cd "$REPO_NAME"

    log "Stowing configs" info
    run stow zshrc
    run stow ghostty
    run stow nvim
    run stow starship
else
    log "Failed to clone the repository." error
    exit 1
fi
