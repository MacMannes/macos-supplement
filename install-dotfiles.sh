#!/bin/bash

REPO_URL="https://github.com/MacMannes/dotfiles.git"
REPO_NAME="dotfiles"

source ./colors.sh
source ./functions.sh

ORIGINAL_DIR=$(pwd)

clone_or_update() {
    run cd ~ || exit 1
    if [[ -d "$REPO_NAME" ]]; then
        info §"Repo exists → pulling updates"
        run log_cmd "(cd $REPO_NAME && git pull)"
    else
        info "Cloning dotfiles repo"
        run git clone "$REPO_URL"
    fi
}

clone_or_update
run cd "$REPO_NAME" || exit 1

run stow zshrc
run stow nvim
run stow ghostty
run stow starship

run cd $ORIGINAL_DIR
