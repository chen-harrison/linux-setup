#!/usr/bin/env bash
set -e

# Make sure this directory exists
mkdir -p ~/.local/bin

# Nerd Fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/UbuntuMono.zip
unzip UbuntuMono.zip -d UbuntuMono
mkdir -p /usr/share/fonts/truetype
sudo mv UbuntuMono /usr/share/fonts/truetype
rm UbuntuMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/DroidSansMono.zip
unzip DroidSansMono.zip -d DroidSansMono
mkdir -p /usr/share/fonts/opentype
sudo mv DroidSansMono /usr/share/fonts/opentype
rm DroidSansMono.zip
fc-cache -f

# fd
fd_url=$(curl -s https://api.github.com/repos/sharkdp/fd/releases/latest | jq -r '.assets[].browser_download_url' | grep -e "fd_.*amd64.deb")
wget -O fd.deb "$fd_url"
dpkg -i fd.deb
rm fd.deb

# bat
bat_url=$(curl -s https://api.github.com/repos/sharkdp/bat/releases/latest | jq -r '.assets[].browser_download_url' | grep -e "bat_.*amd64.deb")
wget -O bat.deb "$bat_url"
dpkg -i bat.deb
rm bat.deb

# ncdu
ncdu_url=$(curl -s https://dev.yorhel.nl/download | grep -oP 'ncdu-[\d.]+-linux-x86_64\.tar\.gz' | sort -V | tail -1)
wget -O ncdu.tar.gz "$ncdu_url"
sudo tar -xzf ncdu.tar.gz -C /usr/local/bin ncdu
rm ncdu.tar.gz

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --key-bindings --completion

# fasd
wget -O fasd.zip https://github.com/clvv/fasd/archive/refs/tags/1.0.1.zip
unzip fasd.zip
cd fasd-1.0.1 && sudo make install && cd ..
rm -r fasd.zip fasd-1.0.1

# nnn
nnn_url=$(curl -s https://api.github.com/repos/jarun/nnn/releases/latest | jq -r '.assets[].browser_download_url' | grep nerd-static)
wget -O nnn.tar.gz "$nnn_url"
tar -xzf nnn.tar.gz
sudo mv nnn-nerd-static /usr/local/bin/nnn
rm nnn.tar.gz
sh -c "$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)"

# tldr-pages
sudo apt-get install pipx
pipx ensurepath
pipx install tldr

# TODO: fix thefuck installation

source ~/.profile
source ~/.bashrc
