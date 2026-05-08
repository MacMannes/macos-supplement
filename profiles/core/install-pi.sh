#!/bin/bash

source ${ROOT_DIR}/colors.sh
source ${ROOT_DIR}/functions.sh

if which pi >/dev/null 2>&1; then
    msg "pi already installed"
else
    msg "installing pi"
    run curl -fsSL https://pi.dev/install.sh | sh
fi
