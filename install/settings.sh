#!/usr/bin/env bash
set -e

# Run from repo root
cd "$(dirname "$0")/.."

# Set favorite apps
gsettings set org.gnome.shell favorite-apps \
"['org.gnome.Ptyxis.desktop', \
  'org.gnome.Nautilus.desktop', \
  'firefox.desktop', \
  'code.desktop', \
  'spotify.desktop', \
  'md.obsidian.Obsidian.desktop', \
  'com.anthropic.Claude.desktop']"

# Screen brightness
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature 2400

# Color scheme
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-blue-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Yaru-blue-dark'
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

# Disable system bell sound
gsettings set org.gnome.desktop.wm.preferences audible-bell false

# Shortcuts
gsettings set org.gnome.settings-daemon.plugins.media-keys control-center "['<Super>comma']"

# Chinese keyboard
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('ibus', 'pinyin')]"
gsettings set org.gnome.desktop.input-sources mru-sources "[('xkb', 'us'), ('ibus', 'pinyin')]"
