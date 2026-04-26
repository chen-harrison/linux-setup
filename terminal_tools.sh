#!/usr/bin/env bash
set -e

# Make sure this directory exists
mkdir -p ~/.local/bin

# Nerd Fonts
wget -O UbuntuMono.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/UbuntuMono.zip
unzip -q UbuntuMono.zip -d UbuntuMono
mkdir -p /usr/share/fonts/truetype
sudo mv UbuntuMono /usr/share/fonts/truetype
rm UbuntuMono.zip
wget -O DroidSansMono.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/DroidSansMono.zip
unzip -q DroidSansMono.zip -d DroidSansMono
mkdir -p /usr/share/fonts/opentype
sudo mv DroidSansMono /usr/share/fonts/opentype
rm DroidSansMono.zip
fc-cache -f

# fd
fd_url=$(curl -fsSL https://api.github.com/repos/sharkdp/fd/releases/latest | jq -r '.assets[].browser_download_url' | grep -e "fd_.*amd64.deb")
wget -O fd.deb "$fd_url"
sudo dpkg -i fd.deb
rm fd.deb

# bat
bat_url=$(curl -fsSL https://api.github.com/repos/sharkdp/bat/releases/latest | jq -r '.assets[].browser_download_url' | grep -e "bat_.*amd64.deb")
wget -O bat.deb "$bat_url"
sudo dpkg -i bat.deb
rm bat.deb

# ncdu
ncdu_tarball=$(curl -fsSL https://dev.yorhel.nl/download | grep -oP 'ncdu-[\d.]+-linux-x86_64\.tar\.gz' | sort -V | tail -1)
wget -O ncdu.tar.gz "https://dev.yorhel.nl/download/$ncdu_tarball"
sudo tar -xzf ncdu.tar.gz -C /usr/local/bin ncdu
rm ncdu.tar.gz

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
wget -O ~/.fzf/fzf-git.sh https://raw.githubusercontent.com/junegunn/fzf-git.sh/refs/heads/main/fzf-git.sh
~/.fzf/install --key-bindings --completion
sed -i "s/\/root/\$HOME/g" .fzf.bash

# delta
delta_url=$(curl -fsSL https://api.github.com/repos/dandavison/delta/releases/latest | jq -r '.assets[].browser_download_url' | grep -E "git-delta_.*_amd64.deb")
wget -O delta.deb "$delta_url"
sudo dpkg -i delta.deb
rm delta.deb

# ripgrep
ripgrep_url=$(curl -fsSL https://api.github.com/repos/BurntSushi/ripgrep/releases/latest | jq -r '.assets[].browser_download_url' | grep -E "ripgrep_.*_amd64.deb$")
wget -O ripgrep.deb "$ripgrep_url"
sudo dpkg -i ripgrep.deb
rm ripgrep.deb

# fasd
wget -O fasd.zip https://github.com/clvv/fasd/archive/refs/tags/1.0.1.zip
unzip fasd.zip
cd fasd-1.0.1 && sudo make install && cd ..
rm -r fasd.zip fasd-1.0.1

# nnn
nnn_url=$(curl -fsSL https://api.github.com/repos/jarun/nnn/releases/latest | jq -r '.assets[].browser_download_url' | grep nerd-static)
wget -O nnn.tar.gz "$nnn_url"
tar -xzf nnn.tar.gz
sudo mv nnn-nerd-static /usr/local/bin/nnn
rm nnn.tar.gz
sh -c "$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)"

# tmux
tmux_url=$(curl -fsSL https://api.github.com/repos/tmux/tmux-builds/releases/latest | jq -r '.assets[].browser_download_url' | grep -E "tmux-.*-linux-x86_64.tar.gz")
wget -O tmux.tar.gz "$tmux_url"
sudo tar -xzf tmux.tar.gz -C /usr/bin tmux

# uv + tldr + pre-commit
curl -LsSf https://astral.sh/uv/install.sh | sh
"${HOME}"/.local/bin/uv tool install tldr
"${HOME}"/.local/bin/uv tool install pre-commit --with pre-commit-uv

# TODO: fix thefuck installation

source ~/.profile
source ~/.bashrc
