#!/bin/bash

# Get the absolute path of the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. $SCRIPT_DIR/utils.sh


run_brew_bundle() {
    brewfile="$SCRIPT_DIR/../homebrew/Brewfile"
    if [ -f "$brewfile" ]; then
        # `brew bundle check` exits non-zero when anything is missing, so test it
        # directly — capturing it in $(...) would abort the script under `set -e`
        if brew bundle check --file="$brewfile" >/dev/null 2>&1; then
            warning "The Brewfile's dependencies are already satisfied."
        else
            info "Satisfying missing dependencies with 'brew bundle install'..."
            brew bundle install --file="$brewfile" ||
                warning "Some Brewfile entries failed to install (see output above)."
        fi
    else
        error "Brewfile not found"
        return 1
    fi
}

if [ "$(basename "$0")" = "$(basename "${BASH_SOURCE[0]}")" ]; then
    # Check if Homebrew is installed
    if ! command -v brew &>/dev/null; then
        error "Homebrew is not installed. Please install Homebrew first."
        exit 1
    fi

    read -p "Install Brew bundle? [y/n] " install_bundle

    if [[ "$install_bundle" == "y" ]]; then
        run_brew_bundle
    fi
fi