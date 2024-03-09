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

# TLDR
sudo pip3 install tldr numpy

# SSH key
read -r -p "Email address for SSH key: "
if [[ $REPLY ]] ; then
    ssh-keygen -t ed25519 -C "$REPLY"
else
    echo "No input received, skipping ssh-keygen"
fi

# TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm