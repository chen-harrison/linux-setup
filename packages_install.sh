#!/usr/bin/env bash
set -e

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
    nvtop                           # System monitor for GPU
    ripgrep                         # Improve grep alternative
    shellcheck                      # Shell script analysis
    synaptic                        # Package manager
    texlive                         # LaTeX
    texlive-formats-extra           # LaTeX
    trash-cli                       # Trash from CLI
    tree                            # File structure visualization
    tmux                            # Terminal multiplexer
    ubuntu-restricted-extras        # Media codecs, fonts, etc.
    xsel                            # Clipboard manipulation
)

sudo apt-get update && sudo apt-get install -y "${packages[@]}"

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
read -r -p "Email address for SSH key: " EMAIL
if [[ $EMAIL ]] ; then
    ssh-keygen -t ed25519 -C "$EMAIL"
else
    echo "No input received, skipping ssh-keygen"
fi

# git-credential-libsecret
sudo make --directory=/usr/share/doc/git/contrib/credential/libsecret

# Tmux Plugin Manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# TODO: The dotfile isn't in place when this called, so doesn't work as intended
~/.tmux/plugins/tpm/bin/install_plugins
~/.tmux/plugins/tpm/bin/update_plugins all
