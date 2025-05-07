#!/usr/bin/env bash

# Packages
sudo apt-get update && sudo apt-get install -y \
    python3-pip \
    dconf-editor \
    fd-find \
    ffmpeg \
    git \
    gdb \
    gthumb \
    imagemagick \
    latexmk \
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

# Change remote origin to SSH
script_dir=$(dirname $0)
cd $script_dir
git remote set-url origin git@github.com:chen-harrison/linux-setup.git
git config --local user.name "Harrison Chen"
git config --local user.email "hchen.robotics@gmail.com"

# fd
ln -s $(which fdfind) ~/.local/bin/fd

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --key-bindings --completion

# fasd
wget -O fasd.zip https://github.com/clvv/fasd/archive/refs/tags/1.0.1.zip
unzip fasd.zip
cd fasd-1.0.1 && sudo make install && cd ..
rm -r fasd.zip fasd-1.0.1

# tldr-pages + thefuck
pip3 install --user tldr thefuck

# yt-dlp
wget -O ~/.local/bin/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp
chmod +x ~/.local/bin/yt-dlp

# tex-fmt
wget https://github.com/WGUNDERWOOD/tex-fmt/releases/latest/download/tex-fmt-x86_64-linux.tar.gz
tar -xvzf tex-fmt-x86_64-linux.tar.gz --directory=/usr/bin
rm tex-fmt-x86_64-linux.tar.gz

# Nerd Fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/UbuntuMono.zip
unzip UbuntuMono.zip -d UbuntuMono
sudo mv UbuntuMono /usr/share/fonts/truetype
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/DroidSansMono.zip
unzip DroidSansMono.zip -d DroidSansMono
sudo mv DroidSansMono /usr/share/fonts/opentype
fc-cache -f
rm UbuntuMono.zip DroidSansMono.zip

# nnn
git clone https://github.com/jarun/nnn.git
cd nnn && git tag --sort=-creatordate | head -n1 | xargs git checkout
sudo apt-get install pkg-config libncursesw5-dev libreadline-dev
sudo make strip install O_NERD=1
cd .. && rm -rf nnn

# SSH key
read -r -p "Email address for SSH key: "
if [[ $REPLY ]] ; then
    ssh-keygen -t ed25519 -C "$REPLY"
else
    echo "No input received, skipping ssh-keygen"
fi

# Tmux Plugin Manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# The dotfile isn't in place when this called, so doesn't work as intended
~/.tmux/plugins/tpm/bin/install_plugins
~/.tmux/plugins/tpm/bin/update_plugins all
