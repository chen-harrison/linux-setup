#!/usr/bin/env bash

# Set favorite apps
gsettings set org.gnome.shell favorite-apps \
"['org.gnome.Terminal.desktop', 'org.gnome.Nautilus.desktop', 'firefox.desktop', 'code.desktop', 'org.gnome.Epiphany.WebApp-notion.desktop', 'spotify.desktop']"

# Automatic screen brightness OFF
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false

# Color scheme
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-blue-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Yaru-blue'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Dash to dock
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 40
gsettings set org.gnome.shell.extensions.dash-to-dock show-trash false
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'focus-minimize-or-previews'

# File explorer - folders before files
gsettings set org.gtk.Settings.FileChooser sort-directories-first true

# Stop '[Application] is ready' notification
gsettings set org.gnome.desktop.wm.preferences auto-raise true

# Top bar
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.interface clock-show-weekday true
gsettings set org.gnome.desktop.interface clock-format 12h

# Workspaces on all displays, only applications from current workspace
gsettings set org.gnome.mutter workspaces-only-on-primary false
gsettings set org.gnome.shell.app-switcher current-workspace-only true

# Disable desktop icons
gnome-extensions disable ding@rastersoft.com

# Ubuntu 22.04 video playback fix: https://www.makeuseof.com/things-to-do-after-upgrading-to-ubuntu-2204-lts/
read -r -p "Is this Ubuntu 22.04 [y/N]? "
if [[ "$REPLY" =~ ^[yY]([eE][sS])?$ ]] ; then
    echo "Fixing video playback"
    sudo apt remove -y gstreamer1.0-vaapi
fi

# Dual boot clock correction
read -r -p "Is this a dual-boot configuration [y/N]? "
if [[ "$REPLY" =~ ^[yY]([eE][sS])?$ ]] ; then
    echo "Fixing clock"
    timedatectl set-local-rtc 1 --adjust-system-clock
fi

