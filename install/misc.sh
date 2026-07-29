#!/usr/bin/env bash
set -e
tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

# Installation requirements
sudo apt-get update && sudo apt-get install -y \
    curl \
    wget

# Nerd Fonts
wget -O "${tmp_dir}/UbuntuMono.zip" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/UbuntuMono.zip
unzip -oq "${tmp_dir}/UbuntuMono.zip" -d "${tmp_dir}/UbuntuMono"
mkdir -p /usr/share/fonts/truetype
sudo cp -r "${tmp_dir}/UbuntuMono" /usr/share/fonts/truetype
wget -O "${tmp_dir}/DroidSansMono.zip" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/DroidSansMono.zip
unzip -oq "${tmp_dir}/DroidSansMono.zip" -d "${tmp_dir}/DroidSansMono"
mkdir -p /usr/share/fonts/opentype
sudo cp -r "${tmp_dir}/DroidSansMono" /usr/share/fonts/opentype
fc-cache -f

# Nvidia drivers
sudo ubuntu-drivers install

# SSH key
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""
