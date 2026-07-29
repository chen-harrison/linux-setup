#!/usr/bin/env bash
set -e

# Packages
packages=(
    curl                            # Data transfer tool
    dconf-editor                    # Application for modifying settings
    ffmpeg                          # Audio + video encoder
    gdb                             # Debugging
    gpg                             # Encryption and data signing
    gthumb                          # Image viewer
    htop                            # System monitor for CPU, memory, swap
    imagemagick                     # Image conversion (?)
    ibus-pinyin                     # Chinese keyboard
    jq                              # JSON parser
    latexmk                         # LaTeX
    libsecret-1-dev                 # git-credential-libsecret dependency
    libsecret-tools                 # CLI interface for gnome-keyring
    nvtop                           # System monitor for GPU
    python3-pip                     # Python package manager
    shellcheck                      # Shell script analysis
    software-properties-common      # Provides add-apt-repository
    synaptic                        # Package manager
    texlive                         # LaTeX
    texlive-formats-extra           # LaTeX
    trash-cli                       # Trash from CLI
    tree                            # File structure visualization
    ubuntu-restricted-extras        # Media codecs, fonts, etc.
    xsel                            # Clipboard manipulation
)

sudo apt-get update && sudo \
    DEBIAN_FRONTEND=noninteractive \
    TZ="$(cat /etc/timezone 2>/dev/null || echo "UTC")" \
    apt-get install -y "${packages[@]}"

# git
sudo add-apt-repository -y ppa:git-core/ppa
sudo apt-get update && sudo apt-get install -y git

# git-lfs
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
sudo apt-get update && sudo apt-get install -y git-lfs

# git-credential-libsecret
sudo make --directory=/usr/share/doc/git/contrib/credential/libsecret

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

sudo apt-get update && sudo apt-get install -y \
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

sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit

sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
