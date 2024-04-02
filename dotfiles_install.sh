#!/usr/bin/env bash

git clone https://github.com/chen-harrison/dotfiles.git ~/dotfiles
cd ~/dotfiles
git remote set-url origin git@github.com:chen-harrison/dotfiles.git
./install.sh
