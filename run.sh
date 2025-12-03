#!/bin/bash

# Load shared colors and functions
source ./colors.sh
source ./functions.sh

# -----------------------------
# Unified color legend
# -----------------------------
print_legend() {
    echo ""
    echo "Usage: $0 [--dry-run] [--upgrade] [--reinstall] [--help]"
    echo ""
    echo -e "${info_message}Info message${reset_color}     - general updates and notices"
    echo -e "${success_message}Success message${reset_color}  - successful installs or upgrades"
    echo -e "${warning_message}Warning message${reset_color}  - already installed or minor warnings"
    echo -e "${error_message}Error message${reset_color}    - failed commands"
    echo -e "${tap_message}Tap message${reset_color}      - brew taps"
    echo -e "${formula_message}Formula message${reset_color}  - brew formula installs/upgrades"
    echo -e "${cask_message}Cask message${reset_color}     - brew cask installs/upgrades"
    echo ""
}

# -----------------------------
# Parse arguments
# -----------------------------
DRY_RUN=0
UPGRADE=0
REINSTALL=0
SHOW_HELP=0
SCRIPT_ARGS=()

for arg in "$@"; do
    case "$arg" in
    --dry-run)
        DRY_RUN=1
        SCRIPT_ARGS+=("--dry-run")
        ;;
    --upgrade)
        UPGRADE=1
        SCRIPT_ARGS+=("upgrade")
        ;;
    --reinstall)
        REINSTALL=1
        SCRIPT_ARGS+=("reinstall")
        ;;
    --help) SHOW_HELP=1 ;;
    *) log "Unknown argument: $arg" warn ;;
    esac
done

# Show legend and exit if --help
if [[ $SHOW_HELP -eq 1 ]]; then
    print_legend
    exit 0
fi

# Dry-run message
[[ $DRY_RUN -eq 1 ]] && log "=== DRY RUN: no changes will be made ===" warn

# -----------------------------
# Run scripts sequentially
# -----------------------------
./install-brew.sh "${SCRIPT_ARGS[@]}"
./install-brew-packages.sh "${SCRIPT_ARGS[@]}"
./install-dotfiles.sh "${SCRIPT_ARGS[@]}"
