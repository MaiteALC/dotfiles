#!/bin/bash

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

#######
# Downloads the required dedicated GPU drivers.
#
# Relies on detect_gpu_vendor function to detect the GPU vendor.
#
# Requires:
#   Active sudo privileges. The caller must ensure the user is already authenticated
#   (e.g., by running `sudo -v` beforehand) as this function does not prompt for a password.
#
# Returns:
#   1 - If sudo privileges are missing/expired.
#######
download_gpu_drivers() {
  if ! sudo -n true 2>/dev/null; then
    printf "\n%s\n" " Sudo privileges missing or expired. Unable to download GPU drivers using pacman" >&2
    return 1
  fi

  local GPU_VENDOR
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
}

get_main_render_gpu

download_gpu_drivers
