#!/bin/bash

function fix-user-dir-permissions() {
    chown -R 1000:1000 "root.x86_64/home/$USERNAME"
}

fix-user-dir-permissions
export USERNAME=archlinuxus
export PROJ_DIR="/home/$USERNAME/archlinuxus-scripts"
cd "$PROJ_DIR"

sudo -u $USERNAME install-all-packages-to-repo/user-main.sh
