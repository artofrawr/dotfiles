#!/bin/sh
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
echo "" 

# Install mise - https://mise.jdx.dev
if ! command -v mise >/dev/null 2>&1; then
  echo "INSTALLING: mise"
  curl https://mise.run | sh
fi

# Install oh-my-zsh - https://ohmyz.sh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "INSTALLING: oh-my-zsh"
  KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install zsh-autosuggestions oh-my-zsh plugin
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "INSTALLING: zsh-autosuggestions"
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# Install chezmoi - https://chezmoi.io
if ! command -v chezmoi >/dev/null 2>&1; then
  echo "INSTALLING: chezmoi"
  sh -c "$(curl -fsLS https://get.chezmoi.io)"
fi


# Initialize and apply dotfiles via chezmoi
chezmoi init --apply --source="$SCRIPT_DIR"

echo "DOTFILES: initialized and applied"
echo ""
