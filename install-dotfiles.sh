#!/bin/bash

REPO_URL="https://github.com/MacMannes/dotfiles.git"
REPO_NAME="dotfiles"

clone_or_update() {
    if [[ -d "$REPO_NAME" ]]; then
        log_info "Repo exists → pulling updates"
        log_cmd "(cd $REPO_NAME && git pull)"
    else
        log_info "Cloning dotfiles repo"
        log_cmd git clone "$REPO_URL"
    fi
}

clone_or_update
cd "$REPO_NAME" || exit 1

log_cmd stow zshrc
log_cmd stow nvim
log_cmd stow ghostty
log_cmd stow starship
