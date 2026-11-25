#!/bin/bash

source ${ROOT_DIR}/colors.sh
source ${ROOT_DIR}/functions.sh

PI_EXTENSIONS=(
    "npm:pi-opencode-theme"
    "npm:pi-account-switcher"
    "npm:@ghoseb/pi-askuserquestion"
    "npm:@narumitw/pi-usage"
)

if ! which pi >/dev/null 2>&1; then
    warn "pi not installed — skipping extensions"
    exit 0
fi

for extension in "${PI_EXTENSIONS[@]}"; do
    if grep -qF "\"${extension}\"" "${HOME}/.pi/agent/settings.json" 2>/dev/null; then
        msg "${extension} already installed"
    else
        msg "installing ${extension}"
        run pi install "${extension}"
    fi
done
