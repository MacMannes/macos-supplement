#!/bin/bash

source ${ROOT_DIR}/colors.sh
source ${ROOT_DIR}/functions.sh

if which bun >/dev/null 2>&1; then
    msg "bun already installed"
else
    msg "installing bun"
    run curl -fsSL https://bun.sh/install | bash
fi
