#!/usr/bin/env bash

script_dir=$(dirname $0)
cd $script_dir

sudo apt update

# Necessary packages for installation
sudo apt install -y curl wget gpg

# Firefox (DEB)
sudo snap remove --purge firefox
sudo install -d -m 0755 /etc/apt/keyrings
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null
echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
' | sudo tee /etc/apt/preferences.d/mozilla
sudo apt-get update && sudo apt-get install firefox

# WideVineCdm plugin fix
insert_string='owner @{HOME}/.{firefox,mozilla}/**/gmp-widevinecdm/*/lib*so m,'
if ! grep -Fq "$insert_string" /etc/apparmor.d/usr.bin.firefox ; then
    sudo sed -i "/# per-user firefox configuration/a\  $insert_string" /etc/apparmor.d/usr.bin.firefox
    sudo apparmor_parser --replace /etc/apparmor.d/usr.bin.firefox
fi

# Notion
sudo apt install -y epiphany-browser
unzip notion.zip
sed -i "s/\$USER/$USER/g" org.gnome.Epiphany.WebApp-notion/org.gnome.Epiphany.WebApp-notion.desktop
mv org.gnome.Epiphany.WebApp-notion ~/.local/share/
ln -s ~/.local/share/org.gnome.Epiphany.WebApp-notion/org.gnome.Epiphany.WebApp-notion.desktop ~/.local/share/applications/org.gnome.Epiphany.WebApp-notion.desktop

# melonDS
sudo apt install -y cmake extra-cmake-modules libcurl4-gnutls-dev libpcap0.8-dev libsdl2-dev qtbase5-dev qtbase5-private-dev qtmultimedia5-dev libarchive-dev libzstd-dev libslirp0
unzip melonDS.zip
sed -i "s/\$USER/$USER/g" melonDS/melonDS.desktop
mv melonDS ~/.local/share/
ln -s ~/.local/share/melonDS/melonDS.desktop ~/.local/share/applications/melonDS.desktop

# Spotify
curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt update && sudo apt install -y spotify-client

# VLC
sudo apt install -y vlc

# VS Code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

sudo apt install -y apt-transport-https
sudo apt update
sudo apt install -y code

# VS Code Extensions
cat ${script_dir}/vscode_extensions.txt | while read extension || [[ -n ${extension} ]];
do
    code --install-extension $extension --force
done

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
