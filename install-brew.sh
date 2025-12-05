#!/bin/bash

source ./colors.sh
source ./functions.sh

if command -v brew >/dev/null 2>&1; then
    msg "brew found — updating…"
    run brew update
else
    msg "brew missing — installing…"
    run /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

done_step
