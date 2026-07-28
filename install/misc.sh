#!/usr/bin/env bash
set -e

# Installation requirements
sudo apt-get update && sudo apt-get install -y \
    curl \
    gpg \
    wget

# Nerd Fonts
wget -O UbuntuMono.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/UbuntuMono.zip
unzip -oq UbuntuMono.zip -d UbuntuMono
mkdir -p /usr/share/fonts/truetype
sudo cp -r UbuntuMono /usr/share/fonts/truetype
wget -O DroidSansMono.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/DroidSansMono.zip
unzip -oq DroidSansMono.zip -d DroidSansMono
mkdir -p /usr/share/fonts/opentype
sudo cp -r DroidSansMono /usr/share/fonts/opentype
fc-cache -f

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

read -rp "The system needs to restart in order to apply changes and allow docker to run without sudo. Restart now? [y/N] "
if [[ "$REPLY" =~ ^[yY]([eE][sS])?$ ]] ; then
    sudo reboot
fi
