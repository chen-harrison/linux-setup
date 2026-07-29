#!/usr/bin/env bash
set -e
tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

# Run from repo root
cd "$(dirname "$0")/.."

# Installation requirements
sudo apt-get update -qq && sudo apt-get install -y \
    curl \
    gpg \
    wget

# Firefox (DEB)
sudo apt remove --purge firefox
sudo snap remove --purge firefox
sudo install -d -m 0755 /etc/apt/keyrings
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null
echo -e "Package: firefox\nPin: release o=Ubuntu\nPin-Priority: -1" | sudo tee /etc/apt/preferences.d/mozilla
sudo apt-get update -q && sudo apt-get install -y firefox

# # WideVineCdm plugin fix for Firefox
# insert_string='owner @{HOME}/.{firefox,mozilla}/**/gmp-widevinecdm/*/lib*so m,'
# if ! grep -Fq "$insert_string" /etc/apparmor.d/usr.bin.firefox ; then
#     sudo sed -i "/# per-user firefox configuration/a\  $insert_string" /etc/apparmor.d/usr.bin.firefox
#     sudo apparmor_parser --replace /etc/apparmor.d/usr.bin.firefox
# fi

# Spotify
curl -sS https://download.spotify.com/debian/pubkey_5384CE82BA52C83A.asc | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update -q && sudo apt-get install -y spotify-client

# VLC
sudo apt-get install -y vlc

# VS Code + Extensions
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > "${tmp_dir}/packages.microsoft.gpg"
sudo install -D -o root -g root -m 644 "${tmp_dir}/packages.microsoft.gpg" /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get install -y apt-transport-https
sudo apt-get update -q && sudo apt-get install -y code

cat config/vsc_extensions.txt | while read -r extension || [[ -n ${extension} ]];
do
    code --install-extension "$extension" --force
done

# # VSCodium + Extensions + Icon Change
# wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
#     | gpg --dearmor \
#     | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
# echo -e 'Types: deb\nURIs: https://download.vscodium.com/debs\nSuites: vscodium\nComponents: main\nArchitectures: amd64 arm64\nSigned-by: /usr/share/keyrings/vscodium-archive-keyring.gpg' \
# | sudo tee /etc/apt/sources.list.d/vscodium.sources
# sudo apt-get update -q && sudo apt-get install -y codium

# cat config/vsc_extensions.txt | while read -r extension || [[ -n ${extension} ]];
# do
#     codium --install-extension "$extension" --force
# done

# wget -O "${tmp_dir}/vscodium.svg" "https://raw.githubusercontent.com/VSCodium/vscodium/master/icons/stable/codium_cnl.svg"
# sudo apt install librsvg2-bin
# rsvg-convert -w 512 -h 512 "${tmp_dir}/vscodium.svg" -o "${tmp_dir}/vscodium.png"
# sudo cp /usr/share/pixmaps/vscodium.png /usr/share/pixmaps/vscodium.png.bak
# sudo cp "${tmp_dir}/vscodium.png" /usr/share/pixmaps/vscodium.png

# Obsidian
obsidian_url=$(curl -fsSL https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest | jq -r '.assets[].browser_download_url' | grep 'amd64.deb')
wget -O "${tmp_dir}/obsidian.deb" "$obsidian_url"
sudo dpkg -i "${tmp_dir}/obsidian.deb"

# Dropbox
dropbox_deb=$(curl -fsSL https://linux.dropbox.com/packages/ubuntu | grep -oP 'dropbox_[\d.]+_amd64\.deb' | sort -V | tail -1)
wget -O "${tmp_dir}/dropbox.deb" "https://linux.dropbox.com/packages/ubuntu/$dropbox_deb"
sudo dpkg -i "${tmp_dir}/dropbox.deb"

# Ungoogled Chromium
wget -O "${tmp_dir}/xtradeb-apt-source.deb" https://launchpad.net/~xtradeb/+archive/ubuntu/apps/+files/xtradeb-apt-source_0.6_all.deb
sudo apt install "${tmp_dir}/xtradeb-apt-source.deb"
sudo apt-get update -q && sudo apt-get install ungoogled-chromium

sudo tee /etc/apt/preferences.d/xtradeb <<EOF
Package: *
Pin: release o=LP-PPA-xtradeb-apps
Pin-Priority: 1

Package: ungoogled-chromium*
Pin: release o=LP-PPA-xtradeb-apps
Pin-Priority: 500
EOF

# Claude Desktop
sudo curl -fsSLo /usr/share/keyrings/claude-desktop-archive-keyring.asc https://downloads.claude.ai/claude-desktop/key.asc
echo "deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/claude-desktop-archive-keyring.asc] https://downloads.claude.ai/claude-desktop/apt/stable stable main" | sudo tee /etc/apt/sources.list.d/claude-desktop.list
sudo apt-get update -q && sudo apt-get install -y claude-desktop

# Foxglove Studio
wget -O "${tmp_dir}/foxglove.deb" https://get.foxglove.dev/desktop/latest/foxglove-studio-latest-linux-amd64.deb
sudo dpkg -i "${tmp_dir}/foxglove.deb"
