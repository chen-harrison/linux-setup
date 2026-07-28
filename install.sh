#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

# Change remote origin to SSH + configure user
git remote set-url origin git@github.com:chen-harrison/linux-setup.git
git config --local user.name "Harrison Chen"
git config --local user.email "hchen.robotics@gmail.com"

read -rp "Is this installation for personal (not professional) use? [y/N] "

# Authenticate with sudo at the beginning, which is applied elsewhere
sudo -v

./install/packages.sh
./install/terminal_tools.sh
./install/gui_apps.sh
./install/settings.sh
./install/misc.sh
./install/dotfiles.sh

if [[ "$REPLY" =~ ^[yY]([eE][sS])?$ ]] ; then
    ./install/fun.sh
fi

echo \ "
To-Do:
- Restart to apply Nvidia drivers
- Add public SSH keys where needed (e.g. GitHub)
"
