#!/bin/bash
set -euo pipefail
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

printf "\n"

. "$DOTFILES_DIR/scripts/utils.sh"
. "$DOTFILES_DIR/scripts/prerequisites.sh"
. "$DOTFILES_DIR/scripts/brew-install.sh"

info "Dotfiles installation initialized..."

read -p "Install apps? [y/n] " install_apps

if [[ "$install_apps" == "y" ]]; then
    printf "\n"
    info "===================="
    info "Prerequisites"
    info "===================="

    install_xcode
    install_homebrew
    install_oh_my_zsh

    printf "\n"
    info "===================="
    info "Apps"
    info "===================="

    run_brew_bundle

fi

# Initialize and apply dotfiles via chezmoi
info "===================="
info "Applying Dotfiles"
info "===================="

chezmoi init --apply --source="$DOTFILES_DIR"

success "Dotfiles set up successfully."
printf "\n"
