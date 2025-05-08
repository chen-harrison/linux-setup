#!/usr/bin/env bash

sudo apt-get update

# Necessary packages for installation
sudo apt-get install -y curl gpg wget

# Foxglove Studio (send to download page)
wget -O foxglove.deb https://get.foxglove.dev/desktop/latest/foxglove-studio-latest-linux-amd64.deb
sudo dpkg -i foxglove.deb
rm foxglove.deb

# Uninstall Docker (optional)
read -r -p "Do you want to uninstall an existing version of Docker [y/N]? "
if [[ "$REPLY" =~ ^[yY]([eE][sS])?$ ]] ; then
    echo "Attempting to uninstall Docker"
    sudo apt-get purge -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin \
    docker-ce-rootless-extras

    sudo rm -rf /var/lib/docker
    sudo rm -rf /var/lib/containerd
fi

# Install Docker
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

(sudo groupadd docker ; sudo usermod -aG docker $USER ) || true

# LazyDocker
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

# Nvidia Container Toolkit
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
    && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
        sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
        sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit

sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

# sudo docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi

read -r -p "The system needs to restart in order to apply changes and allow docker to run without sudo. Restart now? [y/N]? "
if [[ "$REPLY" =~ ^[yY]([eE][sS])?$ ]] ; then
    sudo reboot
fi
