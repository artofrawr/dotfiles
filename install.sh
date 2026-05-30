#!/bin/sh
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
echo "" 

# Install Homebrew - https://brew.sh
if ! command -v brew >/dev/null 2>&1; then
  echo "INSTALLING: Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"   # Apple Silicon
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"       # Intel
  fi
fi

# Install Neovim - https://neovim.io
if ! command -v nvim >/dev/null 2>&1; then
  echo "INSTALLING: Neovim"
  brew install neovim
fi


# Install kitty - https://sw.kovidgoyal.net/kitty
if ! command -v kitty >/dev/null 2>&1 && [ ! -d "/Applications/kitty.app" ]; then
  echo "INSTALLING: kitty"
  curl -fsSL https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
fi

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
  brew install chezmoi
fi


# Initialize and apply dotfiles via chezmoi
chezmoi init --apply --source="$SCRIPT_DIR"

echo "DOTFILES: initialized and applied"
echo ""
