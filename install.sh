#!/bin/bash

run_cmd() {
    if [ "$DRY_RUN" = true ]; then
        echo -e " \e[33m[DRY-RUN]\e[0m Would execute: $@"
    else
        "$@"
    fi
}

detect_gpu_vendor() {
    local gpu_info=$(lspci | grep -iE "VGA|3D")
    
    if echo "$gpu_info" | grep -iq "nvidia"; then
        echo "Nvidia"

    elif echo "$gpu_info" | grep -iq "amd\|radeon"; then
        echo "Amd"

    elif echo "$gpu_info" | grep -iq "intel"; then
        echo "Intel"

    else
        echo "Unknown"
    fi
}

#######
# Resolve the path to the card file in /dev/dri/ belonging to a given GPU based on its provided pci address
#
# Arguments:
#   $1 - The pci address of the GPU you want the path to
#
# Outputs:
#   The path to the card file in /dev/dri/
#######
get_gpu_card_path() {
    card_number=$(basename "$(readlink "/dev/dri/by-path/pci-$1-card")")
    echo "/dev/dri/$card_number"
}

#######
# Search trough the /sys/class/drm/ directory to find the available GPUs and obtain their respective pci addresses.
#
# Outputs:
#   An array containing the respective pci addresses to all found (and valid) GPUs.
#######
get_gpu_pci_addresses() {
    local addresses=()

    for card in /sys/class/drm/card?; do
        if [ -e "$card/device/vendor" ]; then
            addresses+=("$(basename "$(readlink -f "$card/device")")")
        fi
    done

    echo "${addresses[@]}"
}

#######
# Resolve a pci address into the respective user-friendly GPU name. 
#
# Arguments:
#   $1 - A pci address. It must contain the original colons and periods, for example: 0000:01:00.0. 
#
# Outputs:
#   The formatted name of the GPU 
#######
get_gpu_name() {
    echo $(lspci -s "$1" | cut -d ':' -f3- | sed 's/^ *//')
}

#######
# Appends environment variables required by Hyprland in './hypr/env_hardware.conf' based on the detected GPU(s).
# The function creates the file if it doesn't exists.
#
# Arguments:
#   $1 - The GPU vendor. Used to determine which variables (and their values) include in env_hardware.conf file
#######
add_env_variables() {
    local pci_addresses=($(get_gpu_pci_addresses))
    local CARD_PATH=""

    if [ "${#pci_addresses[@]}" -eq 1 ]; then
        echo "A single GPU was detected. Automatic configuring the environment variables..."
        CARD_PATH=$(get_gpu_card_path "${pci_addresses[0]}")
    
    else
        echo "More than one GPU detected. Which would you like to use to render Hyprland?"

        while true; do
            local i=0
            for address in "${pci_addresses[@]}"; do
                name=$(get_gpu_name "$address")
                echo "GPU $i - $name"
                ((i++))
            done

            read -p "Select by typing the number of the GPU you want to use: " choice

            chosen_address="${pci_addresses[$choice]}"
            if [[ ! "$choice" =~ ^[0-9]+$ ]] || [ -z "$chosen_address" ]; then
                echo "Invalid option. Try again."
                continue
            else
                CARD_PATH=$(get_gpu_card_path "$chosen_address")
                break
            fi
        done
    fi

    local ENV_FILE="$HOME/dotfiles/hypr/env_hardware.conf"

    if [ ! -d "$(dirname "$ENV_FILE")" ]; then
        echo "\e[31m The ~/dotfiles/hypr directory does not exists! Unable to proceed with the script.\e[0m"
        exit 1
    fi

    run_cmd touch "$ENV_FILE"

    echo "# Hyprland environment variables related to GPU and rendering configurations" > "$ENV_FILE"
    echo "env = XDG_SESSION_TYPE,wayland" >> "$ENV_FILE"

    if [ "$1" = "Nvidia" ]; then
        echo "env = LIBVA_DRIVER_NAME,nvidia" >> "$ENV_FILE"
        echo "env = GBM_BACKEND,nvidia-drm" >> "$ENV_FILE"
        echo "env = __GLX_VENDOR_LIBRARY_NAME,nvidia" >> "$ENV_FILE"
        echo "env = WLR_NO_HARDWARE_CURSORS,1" >> "$ENV_FILE"

    elif [ "$1" = "Amd" ] || [ "$1" = "Intel" ]; then
        echo "# Using Mesa native configurations. Intel and Amd GPUs works without complex confifgurations." >> "$ENV_FILE"

    else
        echo -e "\e[33mWarning: Unrecognized GPU vendor ($1). Proceeding with default settings.\e[0m"
        echo "# Unknown GPU vendor: $1" >> "$ENV_FILE"
    fi

    echo "# GPU used to render hyprland: " >> "$ENV_FILE"
    echo "env = AQ_DRM_DEVICES,$CARD_PATH" >> "$ENV_FILE"
}

echo -e "\e[34m\n---------------------------------------------------------------\e[0m"
echo -e "\e[34mStarting Arch linux ricing configuration + installation script\e[0m"
echo -e "\e[34m---------------------------------------------------------------\e[0m\n"

CONFIG_FOLDERS=("hypr" "waybar" "wofi" "swaync" "kitty" "Kvantum" "fastfetch")
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="$HOME/.rice_backup_$TIMESTAMP"

DRY_RUN=false
if [[ "$1" == "--dry-run" || "$1" == "-d" ]]; then
    DRY_RUN=true
    echo -e "\n\e[33m--- DRY RUN MODE ACTIVATED ---\e[0m"
    echo -e "\e[33mCommands will be printed, but not executed.\e[0m\n"

else
    echo -e "\e[33m  NOTE: This script will create a backup of some configuration directories (if they exist)\e[0m"
    echo -e "\e[33mDirectories to backup: ${CONFIG_FOLDERS[*]} and greetd\n\e[0m"
    echo -e "\e[33mBackup directory path: $BACKUP_DIR \e[0m"

    read -p "Proceed? [Y/n] " confirm
    confirm=$(echo "$confirm" | tr '[:upper:]' '[:lower:]')

    if [[ "$confirm" == "n" || "$confirm" == "no" ]]; then
        echo "\e[31m Script interrupted by the user\e[0m."
        exit 1
    fi

    echo "Please enter your password to allow package downloads"
    sudo -v

    while true; do
        sudo -n -v 
        sleep 60 
        kill -0 "$$" || exit
    done 2>/dev/null &

    echo "Optmizing pacman.conf..."
    # Adds the ILoveCandy easter egg (ASCII Pacman)
    if ! grep -q "ILoveCandy" /etc/pacman.conf; then
        sudo sed -i '/^Color/a ILoveCandy' /etc/pacman.conf
    fi

    sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
    sudo sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 10/' /etc/pacman.conf
    # Multilib repository is required for 32-bit packages
    sudo sed -i '/^#\[multilib\]/,/^#Include = \/etc\/pacman.d\/mirrorlist/ s/^#//' /etc/pacman.conf

    sudo pacman -Sy
fi

GPU_VENDOR=$(detect_gpu_vendor)

run_cmd add_env_variables "$GPU_VENDOR"

echo -e "\n-----------------------------------"
echo "Installing the required packages..."
echo -e "-----------------------------------\n"

case $GPU_VENDOR in
    "Nvidia")
        echo -e "Nvidia GPU detected.\nInstalling Required drivers..."

        run_cmd sudo pacman -S --needed --noconfirm nvidia-open-dkms nvidia-prime nvidia-settings nvidia-utils opencl-nvidia
        ;;

    "Intel")
        echo -e "Intel GPU detected.\nInstalling Required drivers..."

        run_cmd sudo pacman -S --needed --noconfirm  mesa lib32-mesa vulkan-intel lib32-vulkan-intel intel-media-driver libva-intel-driver intel-gpu-tools
        ;;

    "Amd")
        echo -e "AMD GPU detected.\nInstalling Required drivers..."

        run_cmd sudo pacman -S --needed --noconfirm mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon libva-mesa-driver mesa-vdpau
        ;;

    *)
        echo "No dedicated GPU detected, proceeding with normal installation."
        ;;
esac

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
)

AUR_PACKAGES=(
    catppuccin-gtk-theme-mocha
    papirus-folders-catppuccin-git
    pipes.sh
    wlogout
    bibata-cursor-theme-bin
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

run_cmd rm -rf "/tmp/yay/"

echo "Customizing icons with Catppuccin Mocha Red..."

if command -v papirus-folders &> /dev/null; then
    run_cmd papirus-folders -C cat-mocha-red --theme Papirus-Dark

else
    echo -e "\e[31mPackage papirus-folders not founded. Verify the installation.\e[0m"
fi

echo -e "Creating symlinks...\n"

run_cmd mkdir -p "$HOME/.config/"
run_cmd mkdir -p "$BACKUP_DIR"

DOTFILE_FOLDER="$HOME/dotfiles"

for folder in "${CONFIG_FOLDERS[@]}"; do
    SOURCE="$DOTFILE_FOLDER/$folder"
    TARGET="$HOME/.config/$folder"

    if [ -d "$SOURCE" ]; then
        if [ -d "$TARGET" ] || [ -L "$TARGET" ]; then
            run_cmd mv "$TARGET" "$BACKUP_DIR/"
        fi

        run_cmd ln -snf "$SOURCE" "$TARGET"
        echo -e " Linked: $SOURCE -> $TARGET"

    else
        echo -e "\e[33m Folder $folder not found in $DOTFILE_FOLDER\e[0m"
        echo -e "\e[33mSkipping...\e[0m"
    fi
done

run_cmd mv "$HOME/.config/starship.toml" "$BACKUP_DIR/starship.toml"
run_cmd ln -snf "$DOTFILE_FOLDER/starship.toml" "$HOME/.config/starship.toml"
echo " Linked file: starship.toml"

DM_NAME=""
if systemctl is-active --quiet display-manager.service; then
    DM_NAME=$(basename $(readlink /etc/systemd/system/display-manager.service) | sed 's/.service//') 
fi

if [ -z "$DM_NAME" ]; then
    echo "No enabled login manager was found."

    if [ -d "/etc/greetd" ] || [ -L "/etc/greetd" ]; then
        run_cmd sudo mv /etc/greetd "$BACKUP_DIR/"
    fi

    run_cmd sudo ln -snf "$DOTFILE_FOLDER/greetd" "/etc/greetd"

    run_cmd sudo systemctl enable greetd.service
    echo "The login manager Greetd with Tuigreet was enabled"

elif [ $DM_NAME = "greetd" ]; then
    echo "Aplying new configurations to Greetd"

    if [ -d "/etc/greetd" ] || [ -L "/etc/greetd" ]; then
        run_cmd sudo mv /etc/greetd "$BACKUP_DIR/"
    fi

    run_cmd sudo ln -snf "$DOTFILE_FOLDER/greetd" "/etc/greetd"

else
    echo "An enable login manager was founded: $DM_NAME"
    read -p "Would you like to disable it to enable Greetd? [Y/n] " enable

    enable=$(echo "$enable" | tr '[:upper:]' '[:lower:]')

    if [[ "$enable" == "n" || "$enable" == "no" ]]; then
        echo "Your $DM_NAME will be mantained."
    
    else
        run_cmd sudo ln -snf "$DOTFILE_FOLDER/greetd" "/etc/greetd"

        run_cmd sudo systemctl disable "$DM_NAME"
        run_cmd sudo systemctl enable greetd.service

        echo "$DM_NAME disabled and Greetd enabled!"
    fi
fi

touch ~/.zshrc
CUSTOM_ZSH="$DOTFILE_FOLDER/zsh_custom.zsh"

if ! grep -q "source $CUSTOM_ZSH" ~/.zshrc; then
    echo -e "\n# Injected configurations by ricing script" >> ~/.zshrc
    echo "source $CUSTOM_ZSH" >> ~/.zshrc

    echo "Sourced custom Zsh configurations in your ~/.zshrc file"

else
    echo "The zsh_custom.zsh is already sourced in your .zshrc file. Nothing has been chaged."
fi

echo -e "\e[32m------------------------------------------------------\e[0m"
echo -e "\e[32mScript executed successfully!\e[0m"
echo -e "\e[32mReboot your PC and enjoy your Arch Linux with Hyprland\e[0m"
echo -e "\e[32m------------------------------------------------------\e[0m"
