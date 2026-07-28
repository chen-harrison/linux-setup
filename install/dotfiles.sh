#!/usr/bin/env bash
set -e

git clone https://github.com/chen-harrison/dotfiles.git ~/dotfiles

# Change remote origin to SSH + configure user
git -C ~/dotfiles remote set-url origin git@github.com:chen-harrison/dotfiles.git
git -C ~/dotfiles config --local user.name "Harrison Chen"
git -C ~/dotfiles config --local user.email "hchen.robotics@gmail.com"

~/dotfiles/install.sh
source ~/.bashrc

# Tmux Plugin Manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins
~/.tmux/plugins/tpm/bin/update_plugins all
