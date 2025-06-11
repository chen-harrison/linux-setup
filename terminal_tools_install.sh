#!/usr/bin/env bash

# Make sure this directory exists
mkdir -p ~/.local/bin

# fd
sudo apt-get install -y fd-find
ln -s "$(which fdfind)" ~/.local/bin/fd

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --key-bindings --completion

# fasd
wget -O fasd.zip https://github.com/clvv/fasd/archive/refs/tags/1.0.1.zip
unzip fasd.zip
cd fasd-1.0.1 && sudo make install && cd ..
rm -r fasd.zip fasd-1.0.1

# Nerd Fonts
mkdir -p /usr/share/fonts/truetype
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/UbuntuMono.zip
unzip UbuntuMono.zip -d UbuntuMono
sudo mv UbuntuMono /usr/share/fonts/truetype
rm UbuntuMono.zip
mkdir -p /usr/share/fonts/opentype
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/DroidSansMono.zip
unzip DroidSansMono.zip -d DroidSansMono
sudo mv DroidSansMono /usr/share/fonts/opentype
rm DroidSansMono.zip
fc-cache -f

# nnn
git clone https://github.com/jarun/nnn.git
cd nnn && git tag --sort=-creatordate | head -n1 | xargs git checkout
sudo apt-get install -y pkg-config libncursesw5-dev libreadline-dev
sudo make strip install O_NERD=1
cd .. && rm -rf nnn

# tldr-pages
sudo apt-get install pipx
pipx ensurepath
pipx install tldr

# TODO: fix thefuck installation

source ~/.profile
source ~/.bashrc
