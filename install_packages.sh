#!/usr/bin/env bash

# Packages
sudo apt update && sudo apt install -y \
python3-pip \
git \
gdb \
fzf \
shellcheck \
ripgrep \
tree \
nnn \
tmux \
ubuntu-restricted-extras

# # If using Ubuntu 22.04, run this to allow videos to play properly
# sudo apt remove -y gstreamer1.0-vaapi

# tldr
sudo pip3 install tldr numpy

# # Dual boot clock correction
# timedatectl set-local-rtc 1 --adjust-system-clock

# TODO:
# Nvidia drivers