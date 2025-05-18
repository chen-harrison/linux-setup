#!/usr/bin/env bash

cd "$(dirname $0)"

./packages_install.sh
./apps_install.sh
./settings_install.sh
# ./dev_tools_install.sh
./drivers_install.sh
./dotfiles_install.sh

echo \ "
To-Do:
- Restart to apply Nvidia drivers
- Add public SSH keys where needed (e.g. GitHub)
- ./dev_tools_install.sh
"
