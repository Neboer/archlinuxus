#!/bin/bash -e

USERNAME=archlinuxus
PROJ_DIR=/root/archlinuxus-scripts

cd "$PROJ_DIR"
source prepare-arch-env/prepare-mirrors.sh
source prepare-arch-env/prepare-software.sh
source prepare-arch-env/prepare-user.sh
source prepare-arch-env/prepare-yay.sh
source prepare-arch-env/prepare-makepkg.sh
