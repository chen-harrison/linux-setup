#!/usr/bin/env bash
set -e

# Packages
sudo apt-get update && sudo apt-get install -y \
    python3-pip \
    dconf-editor \
    ffmpeg \
    git \
    gdb \
    gthumb \
    htop \
    imagemagick \
    ibus-pinyin \
    latexmk \
    nvtop \
    ripgrep \
    shellcheck \
    synaptic \
    texlive \
    texlive-formats-extra \
    trash-cli \
    tree \
    tmux \
    ubuntu-restricted-extras \
    xsel

# clangd
clangd_url=$(curl -s https://api.github.com/repos/clangd/clangd/releases/latest | jq -r '.assets[].browser_download_url' | grep 'clangd-linux')
clangd_version=$(curl -s "https://api.github.com/repos/clangd/clangd/releases/latest" | jq -r '.tag_name')
wget -O clangd.zip "$clangd_url"
unzip clangd.zip
sudo cp "clangd_$clangd_version/bin/clangd" /usr/local/bin
sudo cp -r "clangd_$clangd_version/lib/clang" /usr/local/lib
sudo ln -sf /usr/local/bin/clangd /usr/bin/clangd
rm -r clangd.zip "clangd_$clangd_version"

# yt-dlp
wget -O ~/.local/bin/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp
chmod +x ~/.local/bin/yt-dlp

# tex-fmt
wget https://github.com/WGUNDERWOOD/tex-fmt/releases/latest/download/tex-fmt-x86_64-linux.tar.gz
sudo tar -xvzf tex-fmt-x86_64-linux.tar.gz --directory=/usr/bin
rm tex-fmt-x86_64-linux.tar.gz

# SSH key
read -r -p "Email address for SSH key: "
if [[ $REPLY ]] ; then
    ssh-keygen -t ed25519 -C "$REPLY"
else
    echo "No input received, skipping ssh-keygen"
fi

# Tmux Plugin Manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# TODO: The dotfile isn't in place when this called, so doesn't work as intended
~/.tmux/plugins/tpm/bin/install_plugins
~/.tmux/plugins/tpm/bin/update_plugins all
