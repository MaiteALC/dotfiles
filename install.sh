#!/bin/bash

run_cmd() {
    if [ "$DRY_RUN" = true ]; then
        echo -e " \e[33m[DRY-RUN]\e[0m Would execute: $@"
    else
        "$@"
    fi
}

echo -e "\e[34m\n---------------------------------------------------------------\e[0m"
echo -e "\e[34mStarting Arch linux ricing configuration + installation script\e[0m"
echo -e "\e[34m---------------------------------------------------------------\e[0m\n"

echo "Please enter your password to allow package downloads"
sudo -v

DRY_RUN=false
if [[ "$1" == "--dry-run" || "$1" == "-d" ]]; then
    DRY_RUN=true
    echo -e "\n\e[33m--- DRY RUN MODE ACTIVATED ---\e[0m"
    echo -e "\e[33mCommands will be printed, but not executed.\e[0m\n"
fi


while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo -e "Permission conceded. Let's start!\n"

CONFIG_FOLDERS=("hypr" "waybar" "wofi" "swaync" "kitty" "Kvantum")

echo -e "\e[33m  WARNING: This script will remove all contents (rm -rf) inside some configuration folders in ~/.config/ to apply the new configurations.\e[0m"
echo -e "Affected folders: ${CONFIG_FOLDERS[*]}\n"
read -p "Proceed? [Y/n] " confirm

confirm=$(echo "$confirm" | tr '[:upper:]' '[:lower:]')

if [[ "$confirm" == "n" || "$confirm" == "no" ]]; then
    echo "\e[31m Script interrupted by the user\e[0m."
    exit 1
fi

echo -e "\n------------------------------------"
echo "Installing the required packages..."
echo -e "------------------------------------\n"

if lspci | grep -iE 'vga|3d' | grep -iq nvidia; then
    echo "Nvidia graphics card detected."
    echo "Installing drivers and dependencies..."

    run_cmd sudo pacman -S --needed --noconfirm nvidia-open-dkms nvidia-prime nvidia-settings nvidia-utils opencl-nvidia

else
    echo "No dedicated graphics card detected, proceeding with normal installation."
fi


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
    htop
    smartmontools
    brightnessctl
    kio-admin

    # Every day utilities
    cliphist
    wl-clip-persist
    udiskie
    sddm
    mpv
    nautilus
    wofi
    satty
    grim

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
    waybar
    kvantum
    swaync
    nwg-displays
    nwg-look
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
)

AUR_PACKAGES=(
    catppuccin-gtk-theme-mocha
    catppuccin-sddm-theme-mocha
    papirus-folders-catppuccin-git
    pipes.sh
    wlogout
    qview
)

AUR_HELPER=""
if command -v yay &> /dev/null; then
    AUR_HELPER="yay"

elif command -v paru &> /dev/null; then
    AUR_HELPER="paru"

else
    echo " Warning: None AUR helper (yay or paru) was found."
    echo "Installing yay automatically..."

    run_cmd sudo pacman -S --needed --noconfirm git base-devel

    git clone https://aur.archlinux.org/yay.git /tmp/yay
    
    cd /tmp/yay && makepkg -si --noconfirm
    AUR_HELPER="yay"

    cd - > /dev/null
fi

echo "Installing AUR packages with $AUR_HELPER..."
$AUR_HELPER -S --needed --noconfirm "${AUR_PACKAGES[@]}"

echo "AUR packages installed."
echo "Installing pacman packages..."

run_cmd sudo pacman -S --needed --noconfirm "${FONT_PACKAGES[@]}" "${TERMINAL_PACKAGES[@]}" "${HYPRLAND_AND_RELATED_PACKAGES[@]}" "${LIBS_AND_PLUGINS[@]}" "${UTIL_PACKAGES[@]}"

echo -e "\nAll required packages installed successfully!"

echo "Customizing icons with Catppuccin Mocha Red..."

if command -v papirus-folders &> /dev/null; then
    run_cmd papirus-folders -C cat-mocha-red --theme Papirus-Dark

else
    echo -e "\e[31mPackage papirus-folders not founded. Verify the installation.\e[0m"
fi

echo -e "Creating symlinks...\n"

run_cmd mkdir -p "$HOME/.config/"

DOTFILE_FOLDER="$HOME/dotfiles"

for folder in "${CONFIG_FOLDERS[@]}"; do
    SOURCE="$DOTFILE_FOLDER/$folder"
    TARGET="$HOME/.config/$folder"

    if [ -d "$SOURCE" ]; then
        run_cmd rm -rf "$TARGET"

        run_cmd ln -sf "$SOURCE" "$TARGET"
        
        echo -e " Linked: $SOURCE -> $TARGET"
    else
        echo -e "\e[33m Folder $folder not found in $DOTFILE_FOLDER\e[0m"
        echo -e "\e[33mSkipping...\e[0m"
    fi
done

run_cmd ln -sf "$DOTFILE_FOLDER/starship.toml" "$HOME/.config/starship.toml"

echo " Linked file: starship.toml"

echo -e "\nLinks created!\n"

run_cmd rm -rf "/tmp/yay/"

echo -e "\e[32m------------------------------------------------------\e[0m"
echo -e "\e[32mScript executed successfully!\e[0m"
echo -e "\e[32mReboot your PC and enjoy your Arch Linux with Hyprland\e[0m"
echo -e "\e[32m------------------------------------------------------\e[0m"
