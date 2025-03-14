#!/bin/bash -e

USERNAME=archlinuxus
PROJ_DIR=/root/archlinuxus-scripts

cd "$PROJ_DIR"
source "$PROJ_DIR/prepare-arch-env/prepare-mirrors.sh"
source "$PROJ_DIR/prepare-arch-env/prepare-software.sh"
source "$PROJ_DIR/prepare-arch-env/prepare-user.sh"
source "$PROJ_DIR/prepare-arch-env/prepare-yay.sh"
source "$PROJ_DIR/prepare-arch-env/prepare-makepkg.sh"
