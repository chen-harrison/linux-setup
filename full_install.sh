#!/usr/bin/env bash

setup_dir=$(dirname $0)
cd $setup_dir

# Ubuntu 22.04 video playback fix
read -r -p "Is this Ubuntu 22.04 [y/N]? "
if [[ "$REPLY" =~ ^[yY]$ ]] ; then
    echo "Fixing video playback"
    sudo apt remove -y gstreamer1.0-vaapi
fi

# Dual boot clock correction
read -r -p "Is this a dual-boot configuration [y/N]? "
if [[ "$REPLY" =~ ^[yY]$ ]] ; then
    echo "Fixing clock"
    timedatectl set-local-rtc 1 --adjust-system-clock
fi

./packages_install.sh
./apps_install.sh
./dev_tools_install.sh

echo \ "
TODO:
- Add SSH key to Github
- Prefix + I in TMUX to install plugins
- Install Nvidia drivers
"