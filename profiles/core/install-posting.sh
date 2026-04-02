#!/bin/bash

source ${ROOT_DIR}/colors.sh
source ${ROOT_DIR}/functions.sh

if which posting >/dev/null 2>&1; then
    msg "posting already installed"
else
    msg "installing posting"
    run uv tool install --python 3.12 posting
fi
