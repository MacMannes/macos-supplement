#!/bin/bash

source ./colors.sh
source ./functions.sh

########################################
# ARGUMENT PARSING
########################################
DRY_RUN=0
SHOW_HELP=0

for arg in "$@"; do
    case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --help) SHOW_HELP=1 ;;
    *)
        warn "Unknown argument: $arg"
        ;;
    esac
done

########################################
# HELP / LEGEND
########################################
print_help() {
    echo
    echo -e "${bold}Available arguments:${reset}"
    echo "  --dry-run     Show what would happen, without doing anything"
    echo "  --help        Show this help"
    echo
    echo -e "${bold}Legend:${reset}"
    echo -e "${cyan}➤${reset} step"
    echo -e "${green}✔${reset} ok"
    echo -e "${yellow}⚠${reset} warning"
    echo
}

if [ $SHOW_HELP -eq 1 ]; then
    print_help
    exit 0
fi

########################################
# Pass dry-run flag to child scripts
########################################
export DRY_RUN

########################################
# RUN SCRIPTS SEQUENTIALLY
########################################
run_script "./install-brew.sh" "Installing Homebrew"
run_script "./install-gum.sh" "Installing gum"

# gum installed, safe to use UI
run_script "./select-brewfiles.sh" "Selecting Brew profiles"
run_script "./install-brewfiles.sh" "Installing selected brew packages"

ok "All done 🎉"
