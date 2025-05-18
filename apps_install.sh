#!/usr/bin/env bash

cd "$(dirname $0)"

sudo apt-get update

# Necessary packages for installation
sudo apt-get install -y curl wget gpg

# Firefox (DEB)
sudo apt remove --purge firefox
sudo snap remove --purge firefox
sudo install -d -m 0755 /etc/apt/keyrings
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null
echo -e "Package: firefox\nPin: release o=Ubuntu\nPin-Priority: -1" | sudo tee /etc/apt/preferences.d/mozilla
sudo apt-get update && sudo apt-get install -y firefox

# WideVineCdm plugin fix
insert_string='owner @{HOME}/.{firefox,mozilla}/**/gmp-widevinecdm/*/lib*so m,'
if ! grep -Fq "$insert_string" /etc/apparmor.d/usr.bin.firefox ; then
    sudo sed -i "/# per-user firefox configuration/a\  $insert_string" /etc/apparmor.d/usr.bin.firefox
    sudo apparmor_parser --replace /etc/apparmor.d/usr.bin.firefox
fi

# melonDS
sudo apt-get install -y cmake extra-cmake-modules libcurl4-gnutls-dev libpcap0.8-dev libsdl2-dev qtbase5-dev qtbase5-private-dev qtmultimedia5-dev libarchive-dev libzstd-dev libslirp0
unzip melonDS.zip
sed -i "s/\$USER/$USER/g" melonDS/melonDS.desktop
mv melonDS ~/.local/share/
ln -s ~/.local/share/melonDS/melonDS.desktop ~/.local/share/applications/melonDS.desktop

# Spotify
curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install -y spotify-client

# VLC
sudo apt-get install -y vlc

# VS Code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

sudo apt-get install -y apt-transport-https
sudo apt-get update
sudo apt-get install -y code

# VS Code Extensions
cat vscode_extensions.txt | while read extension || [[ -n ${extension} ]];
do
    code --install-extension $extension --force
done

# Obsidian
obsidian_url=$(curl -s https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest | jq -r '.assets[].browser_download_url' | grep 'amd64.deb')
wget -O obsidian.deb $obsidian_url
sudo dpkg -i obsidian.deb
rm obsidian.deb

# Discord
wget -O discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
sudo dpkg -i discord.deb
rm discord.deb

# Chrome
wget -O chrome.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
sudo dpkg -i chrome.deb
rm chrome.deb

# Dropbox (send to download page)
firefox https://www.dropbox.com/install-linux
