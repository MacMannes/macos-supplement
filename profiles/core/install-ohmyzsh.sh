#!/bin/bash

source ${ROOT_DIR}/colors.sh
source ${ROOT_DIR}/functions.sh

ZSH="$HOME/.oh-my-zsh"

if [[ ! -d "$ZSH" ]]; then
    msg "Installing oh-my-zsh..."
    run sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    msg "oh-my-zsh already installed (skipping)"
fi
