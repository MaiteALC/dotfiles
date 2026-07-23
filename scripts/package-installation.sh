#!/bin/bash

source ../lib/logging.sh
source ../lib/dry-run.sh
source ../lib/packages.sh

#######
# Outputs the name of the available AUR helper, automatically downloading Yay if none of them was found.
#
# Outputs:
#   The available AUR helper name (yay or paru)
#######
get_aur_helper() {
  local AUR_HELPER=""
  if command -v yay &>/dev/null; then
    AUR_HELPER="yay"

  elif command -v paru &>/dev/null; then
    AUR_HELPER="paru"

  else
    dry_run info "None AUR helper (yay or paru) was found." "Installing yay automatically..."

    dry_run sudo pacman -S --needed --noconfirm git base-devel

    dry_run git clone https://aur.archlinux.org/yay.git /tmp/yay

    dry_run cd /tmp/yay && makepkg -si --noconfirm
    AUR_HELPER="yay"

    dry_run cd - >/dev/null
    dry_run rm -rf "/tmp/yay" >/dev/null
  fi

  printf "%s" $AUR_HELPER
}

#######
# Install the AUR packages defined in $AUR_PACKAGES
#
# Requires:
#   Active sudo privileges. The caller must ensure the user is already authenticated
#   (e.g., by running `sudo -v` beforehand) as this function does not prompt for a password.
######
install_aur_packages() {
  local AUR_HELPER
  AUR_HELPER=$(get_aur_helper)

  dry_run info "Installing AUR packages with $AUR_HELPER..."
  dry_run "$AUR_HELPER" -S --needed --noconfirm "${AUR_PACKAGES[@]}"

  dry_run success "AUR packages installed"
}

# Install the pre defined pacman packages.
#
# Requires:
#   Active sudo privileges. The caller must ensure the user is already authenticated
#   (e.g., by running `sudo -v` beforehand) as this function does not prompt for a password.
install_pacman_packages() {
  dry_run info "Installing pacman packages..."
  dry_run sudo pacman -S --needed --noconfirm "${PACMAN_PACKAGES[@]}"
  dry_run success "Pacman packages installed"
}

install_pacman_packages

if [ "$SKIP_AUR" = true ]; then
  dry_run info "Skipping AUR downloads..."
else
  install_aur_packages
fi
