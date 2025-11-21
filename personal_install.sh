#!/usr/bin/env bash
set -e

# melonDS
sudo apt-get install -y cmake extra-cmake-modules libcurl4-gnutls-dev libpcap0.8-dev libsdl2-dev qtbase5-dev qtbase5-private-dev qtmultimedia5-dev libarchive-dev libzstd-dev libslirp0
unzip melonDS.zip
sed -i "s/\$USER/$USER/g" melonDS/melonDS.desktop
mv melonDS ~/.local/share/
ln -s ~/.local/share/melonDS/melonDS.desktop ~/.local/share/applications/melonDS.desktop

# Discord
wget -O discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
sudo dpkg -i discord.deb
rm discord.deb