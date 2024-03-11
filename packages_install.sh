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

# Change origin to SSH
script_dir=$(dirname $0)
cd $script_dir
git remote set-url origin git@github.com:chen-harrison/linux-setup.git

# TLDR
sudo pip3 install tldr numpy

# SSH key
read -r -p "Email address for SSH key: "
if [[ $REPLY ]] ; then
    ssh-keygen -t ed25519 -C "$REPLY"
else
    echo "No input received, skipping ssh-keygen"
fi

# Dotfiles
git clone https://github.com/chen-harrison/dotfiles.git ~/dotfiles
cd ~/dotfiles
git remote set-url origin git@github.com:chen-harrison/dotfiles.git
./install.sh

# TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins

# Nvidia drivers
sudo ubuntu-drivers install