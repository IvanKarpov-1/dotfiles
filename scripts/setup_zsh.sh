#!/bin/sh

set -ex

chsh -s "$(which zsh)"

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
ZSH_DIR="$(dirname "$SCRIPT_DIR")/zsh"

git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
