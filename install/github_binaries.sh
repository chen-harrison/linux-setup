#!/usr/bin/env bash
set -e

# Pass --update to check installed tools against their latest GitHub release instead of reinstalling unconditionally
update=false
[[ "$1" == "--update" ]] && update=true

# Install required pacakges
sudo apt-get update -qq && sudo apt-get install -y \
    curl \
    jq \
    unzip \
    wget

# Install yq if it doesn't exist
if ! command -v yq &> /dev/null ; then
    yq_url=$(curl -fsSL https://api.github.com/repos/mikefarah/yq/releases/latest | jq -r '.assets[].browser_download_url' | grep -e "yq_linux_amd64$")
    wget -qO yq "$yq_url"
    chmod +x yq
    sudo mv yq /usr/local/bin/yq
fi

# Maintain a file that tracks the release branches of each package
versions_file="$(cd "$(dirname "$0")" && pwd)/../config/package_versions.yaml"
[ -f "$versions_file" ] || echo "{}" > "$versions_file"

# Get the download URL for an asset from a GitHub repo by providing a grep pattern
# \param $1 GitHub repo in the format <user>/<repo>
# \param $2 grep pattern string
get_asset_url() {
    local repo="$1" pattern="$2"
    local release_json latest_tag asset_url
    release_json=$(curl -fsSL "https://api.github.com/repos/${repo}/releases/latest")
    latest_tag=$(jq -r '.tag_name' <<< "$release_json")

    if $update ; then
        local stored_tag
        stored_tag=$(yq -r ".\"$repo\" // \"\"" "$versions_file")

        [ "$latest_tag" = "$stored_tag" ] && return 1
        echo -e "\e[0;32m$repo\e[0m  $stored_tag -> $latest_tag" >&2
    fi

    asset_url=$(jq -r '.assets[].browser_download_url' <<< "$release_json" | grep -e "$pattern" | head -n1)
    echo "$asset_url"

    yq -i ".\"$repo\" = \"$latest_tag\"" "$versions_file"
}

# Make sure this directory exists
mkdir -p ~/.local/bin

# Create multiple representations of device arch, since packages use diff conventions
dpkg_arch=$(dpkg --print-architecture)  # amd64 or arm64
uname_arch=$(uname -m)                  # x86_64 or aarch64
mixed_arch=$uname_arch                  # x86_64 or arm64
[[ "$mixed_arch" == "aarch64" ]] && mixed_arch=$dpkg_arch

tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

# Move to tmp_dir to simplify file pathing in below commands
cd "$tmp_dir"

# fd
if fd_deb_url=$(get_asset_url "sharkdp/fd" "fd_.*${dpkg_arch}\.deb") ; then
    wget -qO fd.deb "$fd_deb_url"
    sudo dpkg -i fd.deb
fi

# bat
if bat_deb_url=$(get_asset_url "sharkdp/bat" "bat_.*${dpkg_arch}\.deb") ; then
    wget -qO bat.deb "$bat_deb_url"
    sudo dpkg -i bat.deb
fi

# ncdu
ncdu_targz=$(curl -fsSL https://dev.yorhel.nl/download | grep -oP "ncdu-[\d.]+-linux-${uname_arch}\.tar\.gz" | sort -V | tail -1)
wget -qO ncdu.tar.gz "https://dev.yorhel.nl/download/${ncdu_targz}"
sudo tar -xzf ncdu.tar.gz -C /usr/local/bin ncdu

# fzf
if ! $update ; then
    rm -rf ~/.fzf
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --key-bindings --completion --no-update-rc
    wget -qO ~/.fzf/fzf-git.sh https://raw.githubusercontent.com/junegunn/fzf-git.sh/refs/heads/main/fzf-git.sh
elif [ -d ~/.fzf ] ; then
    git -C ~/.fzf pull
    ~/.fzf/install --key-bindings --completion --no-update-rc
fi

# delta
if delta_deb_url=$(get_asset_url "dandavison/delta" "git-delta_.*_${dpkg_arch}\.deb") ; then
    wget -qO delta.deb "$delta_deb_url"
    sudo dpkg -i delta.deb
fi

# ripgrep (no .deb file available for arm64, so we extract from a .tar.gz file)
if [[ "$dpkg_arch" == "amd64" ]] ; then
    if ripgrep_deb_url=$(get_asset_url "BurntSushi/ripgrep" "ripgrep_.*_amd64\.deb") ; then
        wget -qO ripgrep.deb "$ripgrep_deb_url"
        sudo dpkg -i ripgrep.deb
    fi
elif [[ "$uname_arch" == "aarch64" ]]; then
    if ripgrep_targz_url=$(get_asset_url "BurntSushi/ripgrep" "ripgrep-.*-aarch64-unknown-linux-gnu\.tar\.gz$") ; then
        wget -qO ripgrep.tar.gz "$ripgrep_targz_url"
        tar -xzf ripgrep.tar.gz -C /usr/bin --strip-components=1 --wildcards '*/rg'
    fi
fi

# fasd
if ! $update ; then
    wget -qO fasd.zip https://github.com/clvv/fasd/archive/refs/tags/1.0.1.zip
    unzip -o fasd.zip
    sudo make -C fasd-1.0.1 install
fi

# nnn
if nnn_targz_url=$(get_asset_url "jarun/nnn" "nerd-static") ; then
    wget -qO nnn.tar.gz "$nnn_targz_url"
    tar -xzf nnn.tar.gz
    sudo cp nnn-nerd-static /usr/local/bin/nnn

    if ! $update ; then
        yes o | sh -c "$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)"
    fi
fi

# tmux
if tmux_targz_url=$(get_asset_url "tmux/tmux-builds" "tmux-.*-linux-${mixed_arch}\.tar\.gz") ; then
    wget -qO tmux.tar.gz "$tmux_targz_url"
    sudo tar -xzf tmux.tar.gz -C /usr/bin tmux
fi

# Lazygit
if lazygit_targz_url=$(get_asset_url "jesseduffield/lazygit" "lazygit_.*linux_${mixed_arch}\.tar\.gz") ; then
    wget -qO lazygit.tar.gz "$lazygit_targz_url"
    tar -xzf lazygit.tar.gz -C ~/.local/bin lazygit
fi

# Mutagen
if mutagen_targz_url=$(get_asset_url "mutagen-io/mutagen" "mutagen_linux_${dpkg_arch}_.*\.tar\.gz") ; then
    wget -qO mutagen.tar.gz "$mutagen_targz_url"
    sudo tar -xzf mutagen.tar.gz -C /usr/local/bin
fi

# clangd
if clangd_url=$(get_asset_url "clangd/clangd" "clangd-linux") ; then
    wget -qO clangd.zip "$clangd_url"
    unzip -q clangd.zip
    sudo cp clangd_*/bin/clangd /usr/local/bin
    sudo cp -r clangd_*/lib/clang /usr/local/lib
    sudo ln -sf /usr/local/bin/clangd /usr/bin/clangd
fi

# latexindent
latexindent_pattern="latexindent-linux$"
[[ "$dpkg_arch" == "arm64" ]] && latexindent_pattern="latexindent-linux-arm64$"
if latexindent_url=$(get_asset_url "cmhughes/latexindent.pl" "$latexindent_pattern") ; then
    wget -qO latexindent-linux "$latexindent_url"
    chmod +x latexindent-linux
    sudo cp latexindent-linux /usr/local/bin/latexindent
fi

# yt-dlp
if yt_dlp_url=$(get_asset_url "yt-dlp/yt-dlp" "yt-dlp$") ; then
    wget -qO ~/.local/bin/yt-dlp "$yt_dlp_url"
    chmod +x ~/.local/bin/yt-dlp
fi

# Lazydocker
curl -fsSL https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash &> /dev/null

# prek
if ! $update ; then
    curl --proto '=https' --tlsv1.2 -LsSf https://github.com/j178/prek/releases/latest/download/prek-installer.sh | sh
elif command -v prek &> /dev/null ; then
    prek self update
fi

# uv + tldr
if ! $update ; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    ~/.local/bin/uv tool install tldr
elif command -v uv &> /dev/null ; then
    uv self update
    uv tool upgrade --all
fi

# TODO: fix thefuck installation

source ~/.profile
source ~/.bashrc
