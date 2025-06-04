#!/usr/bin/env bash

git clone https://github.com/chen-harrison/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Change remote origin to SSH + configure user
git remote set-url origin git@github.com:chen-harrison/dotfiles.git
git config --local user.name "Harrison Chen"
git config --local user.email "hchen.robotics@gmail.com"

./install.sh
