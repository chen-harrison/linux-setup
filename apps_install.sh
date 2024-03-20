#!/usr/bin/env bash

script_dir=$(dirname $0)
cd $script_dir

sudo apt update

# Necessary packages for installation
sudo apt install -y curl wget gpg

# Firefox (DEB)
sudo add-apt-repository ppa:mozillateam/ppa
echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001

Package: firefox
Pin: version 1:1snap1-0ubuntu2
Pin-Priority: -1
' | sudo tee /etc/apt/preferences.d/mozilla-firefox
sudo snap remove --purge firefox
sudo apt install -y xul-ext-ubufox firefox
echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox

# Notion
sudo apt install -y epiphany-browser
unzip notion.zip
sed -i "s/\$USER/$USER/g" org.gnome.Epiphany.WebApp-notion/org.gnome.Epiphany.WebApp-notion.desktop
mv org.gnome.Epiphany.WebApp-notion ~/.local/share/
ln -s ~/.local/share/org.gnome.Epiphany.WebApp-notion/org.gnome.Epiphany.WebApp-notion.desktop ~/.local/share/applications/org.gnome.Epiphany.WebApp-notion.desktop

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

# Dropbox (send to Download page)
firefox https://www.dropbox.com/install-linux

gsettings set org.gnome.shell favorite-apps \
"['org.gnome.Terminal.desktop', 'org.gnome.Nautilus.desktop', 'firefox.desktop', 'org.gnome.Epiphany.WebApp-notion.desktop', 'code.desktop', 'spotify.desktop']"
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false
gsettings set org.gnome.desktop.interface clock-format 12h