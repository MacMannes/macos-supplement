#!/bin/bash

source ./colors.sh
source ./functions.sh

if brew list gum >/dev/null 2>&1; then
    msg "gum already installed"
else
    msg "installing gum"
    run brew install gum
fi

done_step
