#!/bin/bash
#
# Manifest of all packages required for the rice setup.

_SYSTEM=(
  # Audio
  pasystray
  pavucontrol
  pipewire-alsa
  pipewire-jack
  pipewire-pulse
  playerctl
  sof-firmware

  # Network
  network-manager-applet
  networkmanager

  # Power
  powertop
  tlp-rdw

  # Monitoring
  btop
  smartmontools

  # Brightness
  brightnessctl

  # Bluetooth
  blueman
  bluez
  bluez-utils
)

_UTILITIES=(
  # Directories
  xdg-user-dirs-gtk

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
)

_AESTHETICS=(
  cmatrix
  cava
  fastfetch
  papirus-icon-theme
)

_TERMINAL=(
  zsh
  zsh-autosuggestions
  zsh-syntax-highlighting
  kitty
  starship
)

_FONTS=(
  ttf-droid
  ttf-jetbrains-mono-nerd
  ttf-opensans
  ttf-roboto
  woff2-font-awesome
)

_HYPRLAND=(
  hyprland
  hyprcursor
  hypridle
  hyprlock
  hyprpaper
  hyprpicker
  hyprshot
  hyprsunset
  hyprpolkitagent
)

_LOGIN_MANAGER=(
  greetd
  greetd-tuigreet
)

_LIBS=(
  ffmpegthumbs
  libappindicator-gtk3
  libdbusmenu-gtk3
  libnotify
)

_MEDIA_CODECS=(
  gst-libav
  gst-plugin-pipewire
  gst-plugins-bad
  gst-plugins-base
  gst-plugins-good
  gst-plugins-ugly
)

_WAYLAND_PORTALS=(
  xdg-desktop-portal-gtk
  xdg-desktop-portal-hyprland
)

_QT_THEMING=(
  qt5-graphicaleffects
  qt5-imageformats
  qt5-quickcontrols
  qt5-quickcontrols2
  qt5-wayland
  qt6-wayland

  qt5ct
  qt6ct

  kvantum
  kvantum-qt5
)

_GTK_THEMING=(
  nwg-displays
  nwg-look
)

_NVIM_AND_RELATED=(
  gcc
  make
  neovim
  tree-sitter-cli
  ripgrep
  fd
)

export PACMAN_PACKAGES=(
  "${_SYSTEM[@]}"
  "${_UTILITIES[@]}"
  "${_AESTHETICS[@]}"
  "${_FONTS[@]}"
  "${_TERMINAL[@]}"
  "${_LIBS[@]}"
  "${_MEDIA_CODECS[@]}"
  "${_WAYLAND_PORTALS[@]}"
  "${_HYPRLAND[@]}"
  "${_LOGIN_MANAGER[@]}"
  "${_QT_THEMING[@]}"
  "${_GTK_THEMING[@]}"
  "${_NVIM_AND_RELATED[@]}"
)

export AUR_PACKAGES=(
  catppuccin-gtk-theme-mocha
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
