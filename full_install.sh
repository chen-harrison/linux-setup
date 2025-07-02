#!/usr/bin/env bash

cd "$(dirname $0)"

# Change remote origin to SSH + configure user
cd $(dirname $0)
git remote set-url origin git@github.com:chen-harrison/linux-setup.git
git config --local user.name "Harrison Chen"
git config --local user.email "hchen.robotics@gmail.com"

read -r -p "Is this installation for personal (not professional) use [y/N]? " personal

sudo -v

./packages_install.sh
./terminal_tools_install.sh
./apps_install.sh
./settings_install.sh
./dev_tools_install.sh
./drivers_install.sh
./dotfiles_install.sh

if [[ "$personal" =~ ^[yY]([eE][sS])?$ ]] ; then
    ./personal_install.sh
fi

echo \ "
To-Do:
- Restart to apply Nvidia drivers
- Add public SSH keys where needed (e.g. GitHub)
"
