#!/usr/bin/env bash

# Packages
sudo apt update && sudo apt install -y \
    python3-pip \
    git \
    gdb \
    fzf \
    shellcheck \
    ripgrep \
    tree \
    nnn \
    tmux \
    ubuntu-restricted-extras

# tldr
sudo pip3 install tldr numpy