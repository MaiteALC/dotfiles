#!/bin/bash

dry_run() {
  local YELLOW='\033[0;33m'
  local NO_COLOR='\033[0m'

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
  wlogout
  bibata-cursor-theme-bin
)

install_packages() {
  DRY_RUN=false
  if [[ "$1" == "--dry-run" || "$1" == "-d" ]]; then
    DRY_RUN=true
  fi

  dry_run printf "\n%s\n" "-----------------------------------"
  dry_run printf "%s\n" "Installing the required packages..."
  dry_run printf "%s\n" "-----------------------------------"

  AUR_HELPER=""
  if command -v yay &>/dev/null; then
    AUR_HELPER="yay"

  elif command -v paru &>/dev/null; then
    AUR_HELPER="paru"

  else
    dry_run printf "%s\n" " Warning: None AUR helper (yay or paru) was found."
    dry_run printf "%s\n" "Installing yay automatically..."

    dry_run sudo pacman -S --needed --noconfirm git base-devel

    dry_run git clone https://aur.archlinux.org/yay.git /tmp/yay

    dry_run cd /tmp/yay && makepkg -si --noconfirm
    AUR_HELPER="yay"

    dry_run cd - >/dev/null
  fi

  dry_run printf "\n%s\n" "Installing pacman packages..."
  dry_run sudo pacman -S --needed --noconfirm "${FONT_PACKAGES[@]}" "${TERMINAL_PACKAGES[@]}" "${HYPRLAND_AND_RELATED_PACKAGES[@]}" "${LIBS_AND_PLUGINS[@]}" "${UTIL_PACKAGES[@]}" "${NVIM_PACKAGES[@]}"

  dry_run printf "\n%s\n" "Installing AUR packages with $AUR_HELPER..."
  dry_run $AUR_HELPER -S --needed --noconfirm "${AUR_PACKAGES[@]}"
  dry_run printf "%s\n" "AUR packages installed."

  dry_run printf "\n%s\n\n" "All required packages installed successfully!"

  dry_run rm -rf "/tmp/yay"
}
