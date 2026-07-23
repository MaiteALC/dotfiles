#!/bin/bash
#
# Manifest of all packages required for the rice setup.

UTILITIES=(
  # Audio
  pasystray
  pavucontrol
  pipewire-alsa
  pipewire-jack
  pipewire-pulse
  playerctl
  sof-firmware

  # System
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

TERMINAL=(
  zsh
  zsh-autosuggestions
  zsh-syntax-highlighting
  kitty
  starship
)

FONT=(
  ttf-droid
  ttf-jetbrains-mono-nerd
  ttf-opensans
  ttf-roboto
  woff2-font-awesome
)

HYPRLAND_AND_RELATED=(
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

NVIM_AND_RELATED=(
  gcc
  make
  neovim
  tree-sitter-cli
  ripgrep
  fd
)

export PACMAN_PACKAGES=(
  "${FONT[@]}"
  "${UTILITIES[@]}"
  "${LIBS_AND_PLUGINS[@]}"
  "${TERMINAL[@]}"
  "${HYPRLAND_AND_RELATED[@]}"
  "${NVIM_AND_RELATED[@]}"
)

export AUR_PACKAGES=(
  papirus-folders-catppuccin-git
  pipes-rs
  tty-clock
  cbonsai
  wlogout
  bibata-cursor-theme-bin
)

export NVIDIA_DRIVERS=(
  nvidia-open-dkms
  nvidia-prime
  nvidia-settings
  nvidia-utils
  opencl-nvidia
)

export INTEL_DRIVERS=(
  mesa
  lib32-mesa
  vulkan-intel
  lib32-vulkan-intel
  intel-media-driver
  libva-intel-driver
  intel-gpu-tools
)

export AMD_DRIVERS=(
  mesa
  lib32-mesa
  vulkan-radeon
  lib32-vulkan-radeon
  libva-mesa-driver
  mesa-vdpau
)
