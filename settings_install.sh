#!/usr/bin/env bash

# Set favorite apps
gsettings set org.gnome.shell favorite-apps \
"['org.gnome.Terminal.desktop', 'org.gnome.Nautilus.desktop', 'firefox.desktop', 'org.gnome.Epiphany.WebApp-notion.desktop', 'code.desktop', 'spotify.desktop']"

# Automatic screen brightness OFF
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false

# Dark mode
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Stop '[Application] is ready' notification
gsettings set org.gnome.desktop.wm.preferences auto-raise true

# Battery percentage + clock 12-hour format
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.interface clock-format 12h

# Workspaces on all displays, only applications from current workspace
gsettings set org.gnome.mutter workspaces-only-on-primary false
gsettings set org.gnome.shell.app-switcher current-workspace-only true

# Disable desktop icons
gnome-extensions disable ding@rastersoft.com

# Ubuntu 22.04 video playback fix: https://www.makeuseof.com/things-to-do-after-upgrading-to-ubuntu-2204-lts/
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

