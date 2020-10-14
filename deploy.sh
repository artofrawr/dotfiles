#!/bin/bash

# prep
SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
PYTHON_VERSION='3.8.6'
source $SCRIPTPATH/utils.sh

# -------------------------
# HOMEBREW 
# -------------------------
print_in_purple "HOMEBREW \n"

if ! cmd_exists "brew"; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi
brew update
brew upgrade
print_success "homebrew installed \n"

while read p; do
  brew install $p
done <$SCRIPTPATH/apps/brew.txt
print_success "homebrew packages installed \n"

while read p; do
  brew cask install $p
done <$SCRIPTPATH/apps/casks.txt
print_success "homebrew casks installed \n"

# -------------------------
# SYMLINKS 
# -------------------------
print_in_purple "SYMLINKS \n"
cd $SCRIPTPATH

backupIfNotSymlink ~/.zshrc
backupIfNotSymlink ~/.gitconfig
backupIfNotSymlink ~/.zsh
backupIfNotSymlink ~/Library/Application\ Support/Code/User/settings.json

git clone https://github.com/seebi/dircolors-solarized ~/.dircolors-solarized
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

ln -v -s ~/.dircolors-solarized/dircolors.ansi-dark ~/.dircolors
ln -v -s $SCRIPTPATH/configs/zshrc ~/.zshrc
ln -v -s $SCRIPTPATH/configs/vscode.json ~/Library/Application\ Support/Code/User/settings.json
cp -v $SCRIPTPATH/configs/gitconfig ~/.gitconfig


# -------------------------
# PYTHON 
# -------------------------
print_in_purple "PYTHON \n"
version=$(python -V 2>&1)
if [[ $version != "Python $PYTHON_VERSION" ]]; then
  pyenv install $PYTHON_VERSION
  pyenv global $PYTHON_VERSION
fi
print_success "python installed \n"
