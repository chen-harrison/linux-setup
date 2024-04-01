#!/usr/bin/env bash

# Packages
sudo apt update && sudo apt install -y \
    python3-pip \
    fd-find \
    git \
    gdb \
    shellcheck \
    ripgrep \
    tree \
    nnn \
    dconf-editor \
    synaptic \
    tmux \
    ubuntu-restricted-extras \
    xsel

# Change remote origin to SSH
script_dir=$(dirname $0)
cd $script_dir
git remote set-url origin git@github.com:chen-harrison/linux-setup.git

# fd
ln -s $(which fdfind) ~/.local/bin/fd

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --key-bindings --completion

# tldr-pages + thefuck
pip3 install --user tldr thefuck

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