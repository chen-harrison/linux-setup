#!/usr/bin/env bash
set -e

sudo apt-get update

# Necessary packages for installation
sudo apt-get install -y curl gpg wget

# Foxglove Studio
wget -O foxglove.deb https://get.foxglove.dev/desktop/latest/foxglove-studio-latest-linux-amd64.deb
sudo dpkg -i foxglove.deb
rm foxglove.deb

# Docker
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

(sudo groupadd docker ; sudo usermod -aG docker "$USER") || true

# Nvidia Container Toolkit
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
    && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
        sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
        sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit

sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

# Lazygit
mkdir -p ~/.local/bin
lazygit_version=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${lazygit_version}/lazygit_${lazygit_version}_Linux_x86_64.tar.gz"
tar -xf lazygit.tar.gz -C ~/.local/bin lazygit
rm lazygit.tar.gz

# Lazydocker
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

# Mutagen
mutagen_url=$(curl -s https://api.github.com/repos/mutagen-io/mutagen/releases/latest | jq -r '.assets[].browser_download_url' | grep linux_amd64)
wget -O mutagen.tar.gz "$mutagen_url"
sudo tar -xzf mutagen.tar.gz -C /usr/local/bin
rm mutagen.tar.gz

read -r -p "The system needs to restart in order to apply changes and allow docker to run without sudo. Restart now? [y/N]? "
if [[ "$REPLY" =~ ^[yY]([eE][sS])?$ ]] ; then
    sudo reboot
fi
