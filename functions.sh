#!/bin/bash
# Generic helper functions

# Log messages with descriptive color
# Usage: log "Message" type
# type: info, success, warn, error, tap, formula, cask
log() {
    local msg="$1"
    local type="$2"

    case "$type" in
    success) echo -e "${success_message}${msg}${reset_color}" ;;
    warn) echo -e "${warning_message}${msg}${reset_color}" ;;
    error) echo -e "${error_message}${msg}${reset_color}" ;;
    tap) echo -e "${tap_message}${msg}${reset_color}" ;;
    formula) echo -e "${formula_message}${msg}${reset_color}" ;;
    cask) echo -e "${cask_message}${msg}${reset_color}" ;;
    step) echo -e "${arrow}==>${reset_color} ${info_message}${msg}${reset_color}" ;;
    info | *) echo -e "${info_message}${msg}${reset_color}" ;;
    esac
}

# Execute a command, respecting dry-run mode
# Usage: run command args...
run() {
    local cmd="$*"
    if [[ $DRY_RUN -eq 1 ]]; then
        log "[DRY-RUN] $cmd" info
    else
        eval "$cmd"
    fi
}

# Check if dry-run mode is active
dry_run() {
    [[ "$DRY_RUN" -eq 1 ]]
}
