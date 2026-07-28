#!/usr/bin/env bash
set -e
tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

# melonDS
sudo apt-get update && sudo apt-get install -y \
    cmake \
    extra-cmake-modules \
    libcurl4-gnutls-dev \
    libpcap0.8-dev \
    libsdl2-dev \
    libarchive-dev \
    libenet-dev \
    libzstd-dev \
    libfaad-dev

# Ubuntu 24.04 requirements
sudo apt-get install -y qt6-{base,base-private,multimedia,svg}-dev

melonds_dir=~/.local/share/melonDS
melonds_url=$(curl -fsSL https://api.github.com/repos/melonDS-emu/melonDS/releases/latest | jq -r '.assets[].browser_download_url' | grep -e "melonDS-.*ubuntu-x86_64.zip")
wget -O "${tmp_dir}/melonds.zip" "$melonds_url"
mkdir -p "$melonds_dir"
unzip "${tmp_dir}/melonds.zip" -d "$melonds_dir"
wget -O "${melonds_dir}/melonDS.png" https://raw.githubusercontent.com/melonDS-emu/melonDS/master/res/icon/melon_256x256.png

cat > "${melonds_dir}/melonDS.desktop" << EOF
[Desktop Entry]
Name=melonDS
Exec=/home/$USER/.local/share/melonDS/melonDS
StartupNotify=true
Terminal=false
Type=Application
Categories=Game;
Icon=/home/$USER/.local/share/melonDS/melonDS.png
EOF

ln -sf "${melonds_dir}/melonDS.desktop" ~/.local/share/applications/melonDS.desktop

# Discord
wget -O "${tmp_dir}/discord.deb" "https://discordapp.com/api/download?platform=linux&format=deb"
sudo dpkg -i "${tmp_dir}/discord.deb"
