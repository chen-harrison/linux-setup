#!/usr/bin/env bash
set -e
tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

# Move to tmp_dir to simplify file pathing in below commands
cd "$tmp_dir"

# Make sure this directory exists
mkdir -p ~/.local/bin

# Create multiple representations of device arch, since packages use diff conventions
dpkg_arch=$(dpkg --print-architecture)  # amd64 or arm64
uname_arch=$(uname -m)                  # x86_64 or aarch64
mixed_arch=$uname_arch                  # x86_64 or arm64
[[ "$mixed_arch" == "aarch64" ]] && mixed_arch=$dpkg_arch

# fd
fd_deb_url=$(curl -fsSL https://api.github.com/repos/sharkdp/fd/releases/latest | jq -r '.assets[].browser_download_url' | grep -e "fd_.*${dpkg_arch}\.deb")
wget -O fd.deb "$fd_deb_url"
sudo dpkg -i fd.deb

# bat
bat_deb_url=$(curl -fsSL https://api.github.com/repos/sharkdp/bat/releases/latest | jq -r '.assets[].browser_download_url' | grep -e "bat_.*${dpkg_arch}\.deb")
wget -O bat.deb "$bat_deb_url"
sudo dpkg -i bat.deb

# ncdu
ncdu_targz=$(curl -fsSL https://dev.yorhel.nl/download | grep -oP "ncdu-[\d.]+-linux-${uname_arch}\.tar\.gz" | sort -V | tail -1)
wget -O ncdu.tar.gz "https://dev.yorhel.nl/download/${ncdu_targz}"
sudo tar -xzf ncdu.tar.gz -C /usr/local/bin ncdu

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
wget -O ~/.fzf/fzf-git.sh https://raw.githubusercontent.com/junegunn/fzf-git.sh/refs/heads/main/fzf-git.sh
~/.fzf/install --all
sed -i "s/\/root/\$HOME/g" ~/.fzf.bash

# delta
delta_deb_url=$(curl -fsSL https://api.github.com/repos/dandavison/delta/releases/latest | jq -r '.assets[].browser_download_url' | grep -E "git-delta_.*_${dpkg_arch}\.deb")
wget -O delta.deb "$delta_deb_url"
sudo dpkg -i delta.deb

# ripgrep (no .deb file available for arm64, so we extract from a .tar.gz file)
if [[ "$dpkg_arch" == "amd64" ]] ; then
    ripgrep_deb_url=$(curl -fsSL https://api.github.com/repos/BurntSushi/ripgrep/releases/latest | jq -r '.assets[].browser_download_url' | grep -E "ripgrep_.*_amd64\.deb")
    wget -O ripgrep.deb "$ripgrep_deb_url"
    sudo dpkg -i ripgrep.deb
elif [[ "$uname_arch" == "aarch64" ]]; then
    ripgrep_targz_url=$(curl -fsSL https://api.github.com/repos/BurntSushi/ripgrep/releases/latest | jq -r '.assets[].browser_download_url' | grep -E "ripgrep-.*-aarch64-unknown-linux-gnu\.tar\.gz$")
    wget -O ripgrep.tar.gz "$ripgrep_targz_url"
    tar -xzf ripgrep.tar.gz -C /usr/bin --strip-components=1 --wildcards '*/rg'
fi

# fasd
wget -O fasd.zip https://github.com/clvv/fasd/archive/refs/tags/1.0.1.zip
unzip -o fasd.zip
sudo make -C fasd-1.0.1 install

# nnn
nnn_targz_url=$(curl -fsSL https://api.github.com/repos/jarun/nnn/releases/latest | jq -r '.assets[].browser_download_url' | grep nerd-static)
wget -O nnn.tar.gz "$nnn_targz_url"
tar -xzf nnn.tar.gz
sudo cp nnn-nerd-static /usr/local/bin/nnn
sh -c "$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)"

# tmux
tmux_targz_url=$(curl -fsSL https://api.github.com/repos/tmux/tmux-builds/releases/latest | jq -r '.assets[].browser_download_url' | grep -E "tmux-.*-linux-${mixed_arch}\.tar\.gz")
wget -O tmux.tar.gz "$tmux_targz_url"
sudo tar -xzf tmux.tar.gz -C /usr/bin tmux

# Lazygit
lazygit_targz_url=$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest | jq -r '.assets[].browser_download_url' | grep -E "lazygit_.*linux_${mixed_arch}\.tar\.gz")
wget -O lazygit.tar.gz "$lazygit_targz_url"
tar -xzf lazygit.tar.gz -C ~/.local/bin lazygit

# Mutagen
mutagen_targz_url=$(curl -fsSL https://api.github.com/repos/mutagen-io/mutagen/releases/latest | jq -r '.assets[].browser_download_url' | grep -E "mutagen_linux_${dpkg_arch}_.*\.tar\.gz")
wget -O mutagen.tar.gz "$mutagen_targz_url"
sudo tar -xzf mutagen.tar.gz -C /usr/local/bin

# clangd
clangd_url=$(curl -fsSL https://api.github.com/repos/clangd/clangd/releases/latest | jq -r '.assets[].browser_download_url' | grep clangd-linux)
clangd_version=$(curl -fsSL "https://api.github.com/repos/clangd/clangd/releases/latest" | jq -r '.tag_name')
wget -O clangd.zip "$clangd_url"
unzip -q clangd.zip
sudo cp "clangd_${clangd_version}/bin/clangd" /usr/local/bin
sudo cp -r "clangd_${clangd_version}/lib/clang" /usr/local/lib
sudo ln -sf /usr/local/bin/clangd /usr/bin/clangd

# latexindent
latexindent_bin=latexindent-linux
[[ "$dpkg_arch" == "arm64" ]] && latexindent_bin=latexindent-linux-arm64
wget -O latexindent-linux "https://github.com/cmhughes/latexindent.pl/releases/latest/download/${latexindent_bin}"
chmod +x latexindent-linux
sudo cp latexindent-linux /usr/local/bin/latexindent

# yt-dlp
wget -O ~/.local/bin/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp
chmod +x ~/.local/bin/yt-dlp

# Lazydocker
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

# prek
prek_url=$(curl -fsSL https://api.github.com/repos/j178/prek/releases/latest | jq -r '.assets[].browser_download_url' | grep 'prek-installer.sh')
curl --proto '=https' --tlsv1.2 -LsSf "$prek_url" | sh

# uv + tldr
curl -LsSf https://astral.sh/uv/install.sh | sh
~/.local/bin/uv tool install tldr

# TODO: fix thefuck installation

source ~/.profile
source ~/.bashrc
