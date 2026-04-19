#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

# Change remote origin to SSH + configure user
cd "$(dirname "$0")"
git remote set-url origin git@github.com:chen-harrison/linux-setup.git
git config --local user.name "Harrison Chen"
git config --local user.email "hchen.robotics@gmail.com"

read -r -p "Is this installation for personal (not professional) use? [y/N] "

# Authenticate with sudo at the beginning, which is applied elsewhere
sudo -v

./packages.sh
./terminal_tools.sh
./apps.sh
./settings.sh
./dev_tools.sh
./drivers.sh
./dotfiles.sh

if [[ "$REPLY" =~ ^[yY]([eE][sS])?$ ]] ; then
    ./fun.sh
fi

echo \ "
To-Do:
- Restart to apply Nvidia drivers
- Add public SSH keys where needed (e.g. GitHub)
"
