#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NO_COLOR='\033[0m'

dry_run() {
  if [ "$DRY_RUN" = true ]; then
    printf "%b[DRY-RUN]%b %s\n" "$YELLOW" "$NO_COLOR" "Would execute: $*"
  else
    "$@"
  fi
}

detect_gpu_vendor() {
  local gpu_info
  gpu_info=$(lspci | grep -iE "VGA|3D")

  if printf "%s" "$gpu_info" | grep -iq "nvidia"; then
    printf "Nvidia"

  elif printf "%s" "$gpu_info" | grep -iq "amd\|radeon"; then
    printf "Amd"

  elif printf "%s" "$gpu_info" | grep -iq "intel"; then
    printf "Intel"

  else
    printf "Unknown"
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
  printf "/dev/dri/%s" "$card_number"
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

  printf "%s\n" "${addresses[@]}"
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
  lspci -s "$1" | cut -d ':' -f3- | sed 's/^ *//'
}

#######
# Search for the available GPU(s) and prompt the user to select which one should be used to render Hyprland.
# After the user's choice, it saves GPU data in a state file at '/tmp/hyprland-rice/gpu-info'.
# The file and the directory are created if necessary.
########
get_main_render_gpu() {
  local pci_addresses=($(get_gpu_pci_addresses))
  local CARD_PATH=""
  local GPU_FILE="/tmp/hyprland-rice/gpu-info"

  if [ ! -d "$(dirname "$GPU_FILE")" ]; then
    mkdir /tmp/hyprland-rice
  fi

  touch "$GPU_FILE"

  if [ "${#pci_addresses[@]}" -eq 1 ]; then
    printf "A single GPU was detected. Automatic configuring the environment variables...\n"

    local address
    local name

    address="${pci_addresses[0]}"
    name=$(get_gpu_name "$address")
    CARD_PATH=$(get_gpu_card_path "$address")

    printf "name=%s card_path=%s pci_address=%s" "$name" "$CARD_PATH" "${pci_addresses[0]}" >"$GPU_FILE"
  else
    printf "%s\n" "More than one GPU detected. Which would you like to use to render Hyprland?"

    while true; do
      local i=0
      for address in "${pci_addresses[@]}"; do
        name=$(get_gpu_name "$address")
        printf "%s\n" "GPU $i - $name"
        ((i++))
      done

      printf "%s" "Select by typing the number of the GPU you want to use: "
      read -r choice

      chosen_address="${pci_addresses[$choice]}"

      if [[ ! "$choice" =~ ^[0-9]+$ ]] || [ -z "$chosen_address" ]; then
        printf "%s\n" "Invalid option. Try again."
        continue
      else
        CARD_PATH=$(get_gpu_card_path "$chosen_address")
        local name
        name=$(get_gpu_name "$chosen_address")

        printf "name=%s card_path=%s pci_address=%s" "$name" "$CARD_PATH" "$chosen_address" >"$GPU_FILE"

        break
      fi
    done
  fi
}

printf "\n%b%s\n" "$BLUE" "---------------------------------------------------------------"
printf "%s\n" "Starting Arch linux ricing configuration + installation script"
printf "%s%b\n" "---------------------------------------------------------------" "$NO_COLOR"

DOTFILE_FOLDER="$HOME/dotfiles"
CONFIG_FOLDERS=("hypr" "waybar" "wofi" "swaync" "kitty" "Kvantum" "fastfetch" "nvim")
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="$HOME/.rice_backup_$TIMESTAMP"

DRY_RUN=false
if [[ "$1" == "--dry-run" || "$1" == "-d" ]]; then
  DRY_RUN=true
  printf "\n%b%s\n" "$YELLOW" "--- DRY RUN MODE ACTIVATED ---"
  printf "%s%b\n" "Commands will be printed, but not executed." "$NO_COLOR"

else
  printf "\n%b%s\n" "$YELLOW" "  NOTE: This script will create a backup of some configuration directories (if they exist)"
  printf "%s\n" "Directories to backup: ${CONFIG_FOLDERS[*]} and greetd"
  printf "%s%b\n" "Backup directory path: $BACKUP_DIR" "$NO_COLOR"

  printf "%s" "Proceed? [Y/n] "
  read -r confirm

  confirm=$(printf "%s" "$confirm" | tr '[:upper:]' '[:lower:]')

  if [[ "$confirm" == "n" || "$confirm" == "no" ]]; then
    printf "%b%s%b\n" "$RED" " Script interrupted by the user." "$NO_COLOR"
    exit 1
  fi

  printf "%s\n" "Please enter your password to allow package downloads"
  sudo -v

  while true; do
    sudo -n -v
    sleep 60
    kill -0 "$$" || exit
  done 2>/dev/null &

  printf "%s\n" "Optmizing pacman.conf..."
  # Adds the ILoveCandy easter egg (ASCII Pacman)
  if ! grep -q "ILoveCandy" /etc/pacman.conf; then
    sudo sed -i '/^Color/a ILoveCandy' /etc/pacman.conf
  fi

  sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
  sudo sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 10/' /etc/pacman.conf
  # Multilib repository is required for 32-bit packages
  sudo sed -i '/^#\[multilib\]/,/^#Include = \/etc\/pacman.d\/mirrorlist/ s/^#//' /etc/pacman.conf

  sudo pacman -Sy

  get_main_render_gpu

  GPU_VENDOR=$(detect_gpu_vendor)

  case $GPU_VENDOR in
  "Nvidia")
    printf "%s\n" "Nvidia GPU detected. Installing required drivers..."
    sudo pacman -S --needed --noconfirm nvidia-open-dkms nvidia-prime nvidia-settings nvidia-utils opencl-nvidia
    ;;

  "Intel")
    printf "%s\n" "Intel GPU detected. Installing Required drivers..."

    sudo pacman -S --needed --noconfirm mesa lib32-mesa vulkan-intel lib32-vulkan-intel intel-media-driver libva-intel-driver intel-gpu-tools
    ;;

  "Amd")
    printf "%s\n" "AMD GPU detected. Installing Required drivers..."

    sudo pacman -S --needed --noconfirm mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon libva-mesa-driver mesa-vdpau
    ;;

  *)
    printf "%s\n" "No dedicated GPU detected, proceeding with normal installation."
    ;;
  esac
fi

# shellcheck source=./scripts/package-installation.sh
source "$DOTFILE_FOLDER/scripts/package-installation.sh"
install_packages "$1"

dry_run printf "%s\n" "Customizing icons with Catppuccin Mocha Flamingo..."

if command -v papirus-folders &>/dev/null; then
  dry_run papirus-folders -C cat-mocha-flamingo --theme Papirus-Dark

else
  dry_run printf "%b%s%b\n" "$YELLOW" "Package papirus-folders not founded. Verify the installation." "$NO_COLOR"
fi

dry_run printf "%s\n" "Creating symlinks..."

dry_run mkdir -p "$HOME/.config/"
dry_run mkdir -p "$BACKUP_DIR"

for folder in "${CONFIG_FOLDERS[@]}"; do
  SOURCE="$DOTFILE_FOLDER/$folder"
  TARGET="$HOME/.config/$folder"

  if [ -d "$SOURCE" ]; then
    if [ -d "$TARGET" ] || [ -L "$TARGET" ]; then
      dry_run mv "$TARGET" "$BACKUP_DIR/"
    fi

    dry_run ln -snf "$SOURCE" "$TARGET"
    dry_run printf "%s\n" " Linked: $SOURCE -> $TARGET"

  else
    dry_run printf "%b%s\n" "$RED" " Folder $folder not found in $DOTFILE_FOLDER"
    dry_run printf "%s%b\n" "Skipping..." "$NO_COLOR"
  fi
done

dry_run mv "$HOME/.config/starship.toml" "$BACKUP_DIR/starship.toml"
dry_run ln -snf "$DOTFILE_FOLDER/starship.toml" "$HOME/.config/starship.toml"
dry_run printf "%s\n" " Linked file: starship.toml"

DM_NAME=""
if systemctl is-active --quiet display-manager.service; then
  DM_NAME=$(basename "$(readlink /etc/systemd/system/display-manager.service)" | sed 's/.service//')
fi

if [ -z "$DM_NAME" ]; then
  dry_run printf "%s\n" "No enabled login manager was found."

  if [ -d "/etc/greetd" ] || [ -L "/etc/greetd" ]; then
    dry_run sudo mv /etc/greetd "$BACKUP_DIR/"
  fi

  dry_run sudo ln -snf "$DOTFILE_FOLDER/greetd" "/etc/greetd"

  dry_run sudo systemctl enable greetd.service
  dry_run printf "%s\n" "The login manager Greetd with Tuigreet was enabled"

elif [ "$DM_NAME" = "greetd" ]; then
  dry_run printf "%s\n" "Aplying new configurations to Greetd"

  if [ -d "/etc/greetd" ] || [ -L "/etc/greetd" ]; then
    dry_run sudo mv /etc/greetd "$BACKUP_DIR/"
  fi

  dry_run sudo ln -snf "$DOTFILE_FOLDER/greetd" "/etc/greetd"

else
  dry_run printf "%s\n" "An enable login manager was founded: $DM_NAME"
  dry_run printf "%s" "Would you like to disable it to enable Greetd? [Y/n] "
  dry_run read -r enable

  enable=$(printf "%s" "$enable" | tr '[:upper:]' '[:lower:]')

  if [[ "$enable" == "n" || "$enable" == "no" ]]; then
    dry_run printf "%s\n" "Your $DM_NAME will be mantained."

  else
    dry_run sudo ln -snf "$DOTFILE_FOLDER/greetd" "/etc/greetd"

    dry_run sudo systemctl disable "$DM_NAME"
    dry_run sudo systemctl enable greetd.service

    dry_run printf "%s\n" "$DM_NAME disabled and Greetd enabled!"
  fi
fi

dry_run touch ~/.zshrc
CUSTOM_ZSH="$DOTFILE_FOLDER/scripts/zsh_custom.zsh"

if ! grep -q "source $CUSTOM_ZSH" ~/.zshrc; then
  dry_run printf "\n%s\n" "# Injected configurations by ricing script" >>~/.zshrc
  dry_run printf "%s\n" "source $CUSTOM_ZSH" >>~/.zshrc

  dry_run printf "%s\n" "Sourced custom Zsh configurations in your ~/.zshrc file"

else
  dry_run printf "%s\n" "The zsh_custom.zsh is already sourced in your .zshrc file. Nothing has been chaged."
fi

printf "\n%b%s\n" "$GREEN" "------------------------------------------------------"
printf "%s\n" "Script executed successfully!"
printf "%s\n" "Reboot your PC and enjoy your Arch Linux with Hyprland"
printf "%s%b\n" "------------------------------------------------------" "$NO_COLOR"
