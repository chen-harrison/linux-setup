#!/usr/bin/env bash
set -e

# git PPA
sudo add-apt-repository -y ppa:git-core/ppa

# Packages
packages=(
    python3-pip                     # Python package manager
    dconf-editor                    # Application for modifying settings
    ffmpeg                          # Audio + video encoder
    git                             # Version control
    gdb                             # Debugging
    gthumb                          # Image viewer
    htop                            # System monitor for CPU, memory, swap
    imagemagick                     # Image conversion (?)
    ibus-pinyin                     # Chinese keyboard
    latexmk                         # LaTeX
    libsecret-1-dev                 # git-credential-libsecret dependency
    libsecret-tools                 # CLI interface for gnome-keyring
    nvtop                           # System monitor for GPU
    ripgrep                         # Improve grep alternative
    shellcheck                      # Shell script analysis
    synaptic                        # Package manager
    texlive                         # LaTeX
    texlive-formats-extra           # LaTeX
    trash-cli                       # Trash from CLI
    tree                            # File structure visualization
    ubuntu-restricted-extras        # Media codecs, fonts, etc.
    xsel                            # Clipboard manipulation
)

sudo apt-get update && sudo apt-get install -y "${packages[@]}"

# git-lfs
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
sudo apt-get install git-lfs

# clangd
clangd_url=$(curl -fsSL https://api.github.com/repos/clangd/clangd/releases/latest | jq -r '.assets[].browser_download_url' | grep clangd-linux)
clangd_version=$(curl -fsSL "https://api.github.com/repos/clangd/clangd/releases/latest" | jq -r '.tag_name')
wget -O clangd.zip "$clangd_url"
unzip -q clangd.zip
sudo cp "clangd_$clangd_version/bin/clangd" /usr/local/bin
sudo cp -r "clangd_$clangd_version/lib/clang" /usr/local/lib
sudo ln -sf /usr/local/bin/clangd /usr/bin/clangd
rm -r clangd.zip "clangd_${clangd_version}"

# yt-dlp
wget -O ~/.local/bin/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp
chmod +x ~/.local/bin/yt-dlp

# latexindent
wget https://github.com/cmhughes/latexindent.pl/releases/latest/download/latexindent-linux
chmod +x latexindent-linux
sudo mv latexindent-linux /usr/local/bin/latexindent

# SSH key
read -r -p "Email address for SSH key: " EMAIL
if [[ $EMAIL ]] ; then
    ssh-keygen -t ed25519 -C "$EMAIL"
else
    echo "No input received, skipping ssh-keygen"
fi

# git-credential-libsecret
sudo make --directory=/usr/share/doc/git/contrib/credential/libsecret
