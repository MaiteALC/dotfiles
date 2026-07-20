#!/bin/bash

YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NO_COLOR='\033[0m'

dry_run() {
  if [ "$DRY_RUN" = true ]; then
    printf "%b[DRY-RUN]%b %s\n" "$YELLOW" "$NO_COLOR" "Would execute: $*"
  else
    "$@"
  fi
}

UTIL_PACKAGES=(
  # Audio
  pasystray
  pavucontrol
  pipewire-alsa
  pipewire-jack
  pipewire-pulse
  playerctl
  sof-firmware

  # System utilities
  network-manager-applet
  networkmanager
  polkit-gnome
  polkit-kde-agent
  powertop
  btop
  smartmontools
  brightnessctl
  kio-admin

  # Every day utilities
  cliphist
  wl-clip-persist
  udiskie
  mpv
  nautilus
  wofi
  satty
  grim
  waybar
  swaync

  # Aesthetics
  cmatrix
  cava
  fastfetch
  papirus-icon-theme

  # Bluetooth
  blueman
  bluez
  bluez-utils
)

TERMINAL_PACKAGES=(
  zsh
  zsh-autosuggestions
  zsh-syntax-highlighting
  kitty
  starship
)

FONT_PACKAGES=(
  ttf-droid
  ttf-jetbrains-mono-nerd
  ttf-opensans
  ttf-roboto
  woff2-font-awesome
)

HYPRLAND_AND_RELATED_PACKAGES=(
  hyprcursor
  hypridle
  hyprland
  hyprlock
  hyprpaper
  hyprpicker
  hyprshot
  hyprsunset

  # Config related
  kvantum
  nwg-displays
  nwg-look

  # Login manager
  greetd
  greetd-tuigreet
)

LIBS_AND_PLUGINS=(
  qt5-graphicaleffects
  qt5-imageformats
  qt5-quickcontrols
  qt5-quickcontrols2
  qt5-wayland
  qt5ct
  qt6-wayland
  qt6ct

  xdg-desktop-portal-gtk
  xdg-desktop-portal-hyprland
  xdg-user-dirs-gtk

  gst-libav
  gst-plugin-pipewire
  gst-plugins-bad
  gst-plugins-base
  gst-plugins-good
  gst-plugins-ugly

  kvantum-qt5
  tlp-rdw
  ffmpegthumbs

  libappindicator-gtk3
  libdbusmenu-gtk3
  libnotify
)

NVIM_PACKAGES=(
  gcc
  make
  neovim
  tree-sitter-cli
  ripgrep
  fd
)

AUR_PACKAGES=(
  papirus-folders-catppuccin-git
  pipes-rs
  tty-clock
  cbonsai
  wlogout
  bibata-cursor-theme-bin
)

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
    dry_run printf "%b%s%b\n" "$YELLOW" " Warning: None AUR helper (yay or paru) was found." "$NO_COLOR"
    dry_run printf "%b%s%b\n" "$YELLOW" "Installing yay automatically..." "$NO_COLOR"

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

  dry_run printf "\n%s\n" "Installing AUR packages with $AUR_HELPER..."
  dry_run "$AUR_HELPER" -S --needed --noconfirm "${AUR_PACKAGES[@]}"

  dry_run printf "%b%s%b\n" "$GREEN" "AUR packages installed" "$NO_COLOR"
}

# Install the pre defined pacman packages.
#
# Requires:
#   Active sudo privileges. The caller must ensure the user is already authenticated
#   (e.g., by running `sudo -v` beforehand) as this function does not prompt for a password.
install_pacman_packages() {
  dry_run printf "\n%s\n" "Installing pacman packages..."
  dry_run sudo pacman -S --needed --noconfirm "${FONT_PACKAGES[@]}" "${TERMINAL_PACKAGES[@]}" "${HYPRLAND_AND_RELATED_PACKAGES[@]}" "${LIBS_AND_PLUGINS[@]}" "${UTIL_PACKAGES[@]}" "${NVIM_PACKAGES[@]}"

  dry_run printf "%b%s%b\n" "$GREEN" "Pacman packages installed" "$NO_COLOR"
}

install_pacman_packages

install_aur_packages
