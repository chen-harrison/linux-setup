#!/usr/bin/env bash

script_dir=$(dirname $0)
cd $script_dir

./packages_install.sh
./apps_install.sh
./settings_install.sh
# ./dev_tools_install.sh
./drivers_install.sh
./dotfiles_install.sh

echo \ "
TODO:
- Restart to apply Nvidia drivers
- Add public SSH keys where needed (e.g. GitHub)
- ./dev_tools_install.sh
"