#!/bin/bash

# dependency: source colors.sh first!

__STEP_START_TIME=0
__CURRENT_STEP_NAME=""

msg() {
    echo -e "${dim}$1${reset}"
}

ok() {
    echo -e "${green}✔${reset} $1"
}

warn() {
    echo -e "${yellow}⚠${reset} $1"
}

step() {
    __CURRENT_STEP_NAME="$1"
    __STEP_START_TIME=$(date +%s)

    echo -e "${cyan}➤${reset} ${bold}${__CURRENT_STEP_NAME}${reset}"
}

done_step() {
    local end
    end=$(date +%s)
    local elapsed=$((end - __STEP_START_TIME))

    echo -e "${green}✔${reset} ${bold}${__CURRENT_STEP_NAME}${reset} ${dim}(${elapsed}s)${reset}"
    echo
}

run() {
    echo -e "${dim}$@$reset"
    "$@"
    local status=$?
    if [ $status -ne 0 ]; then
        warn "Command failed: $*"
        exit $status
    fi
}

run_script() {
    local script="$1"
    local label="$2"

    if [[ ! -f "$script" ]]; then
        warn "Script not found: $script"
        exit 1
    fi

    if [[ -z "$label" ]]; then
        label="$script"
    fi

    step "$label"      # start step
    run bash "$script" # execute script
    done_step          # end step with elapsed time
}
