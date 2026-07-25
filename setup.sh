#!/bin/bash

# --- Global variables needed across the script ---
DRY_RUN_MODE=false
STARSHIP=true
LOGIN_MANAGER=true
PACMAN=true
SKIP_DOWNLOADS=false
SKIP_AUR=false
SKIP_GPU=false
SKIP_GPU_DRIVERS=false
REPLACE_DM=false

declare -A config_dirs=(
  [hypr]=true
  [waybar]=true
  [wofi]=true
  [swaync]=true
  [kitty]=true
  [Kvantum]=true
  [fastfetch]=true
  [nvim]=true
  [gtk-3.0]=true
  [gtk-4.0]=true
  [qt5ct]=true
  [qt6ct]=true
  [zsh]=true
  [bat]=true
)
DOTFILES_PATH=$(dirname "$(realpath "$0")")
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="$HOME/.rice_backup_$TIMESTAMP"
# ---------------

source ./lib/logging.sh
source ./lib/dry-run.sh

help_menu() {
  cat <<'EOF'

Usage: setup.sh [OPTIONS]

Sets up the rice by downloading dependencies, backing up previous configs,
and symlinking the repo's configurations to your system.

Options:
  -d, --dry-run           Print commands but do not execute them (test mode)
  --no-kvantum            Skip Kvantum configuration
  --no-fastfetch          Skip Fastfetch configuration
  --no-hyprland           Skip Hyprland configuration
  --no-kitty              Skip Kitty terminal configuration
  --no-nvim               Skip Neovim configuration
  --no-swaync             Skip SwayNC configuration
  --no-waybar             Skip Waybar configuration
  --no-wofi               Skip Wofi configuration
  --no-zsh                Skip Zsh configuration
  --no-starship           Skip Starship plugin configuration
  --no-greetd             Skip Greetd login manager configuration (requires sudo)
  --no-pacman-conf        Skip pacman.conf file optimizations (doesn't automatically activate parallel downloads, ILoveCandy, and multilib)
  --no-downloads          Skip both pacman and AUR package downloads
  --no-aur-downloads      Skip only AUR package downloads
  --no-gpu-drivers        Skip dedicated GPU driver downloads
  --no-gpu-config         Skip all GPU configurations, including driver downloads
  --no-gtk                Skip GTK3 and GTK4 configuration
  --no-qt                 Skip Qt5 and Qt6 configuration
  --replace-dm            Replace the previous login manager if there is other than Greetd active

  -h, --help              Display this help and exit

NOTES:
  At the start of the script, you will be prompted for sudo permissions to configure the pacman.conf file, greetd and install pacman and AUR packages.
  You can audit the full package list by checking the './lib/packages.sh' file.

  Existing configurations (except those that are skipped by --no-* flags) will be backed up to ~/.rice_backup_TIMESTAMP before creating symlinks.
EOF
}

parse_cli_args() {
  while [[ "$#" -gt 0 ]]; do
    case $1 in
    "--dry-run" | "-d")
      DRY_RUN_MODE=true
      shift
      ;;
    "--no-kvantum")
      config_dirs[Kvantum]=false
      shift
      ;;
    "--no-fastfetch")
      config_dirs[fastfetch]=false
      shift
      ;;
    "--no-hyprland")
      config_dirs[hypr]=false
      shift
      ;;
    "--no-kitty")
      config_dirs[kitty]=false
      shift
      ;;
    "--no-nvim")
      config_dirs[nvim]=false
      shift
      ;;
    "--no-swaync")
      config_dirs[swaync]=false
      shift
      ;;
    "--no-waybar")
      config_dirs[waybar]=false
      shift
      ;;
    "--no-wofi")
      config_dirs[wofi]=false
      shift
      ;;
    "--no-zsh")
      config_dirs[zsh]=false
      shift
      ;;
    "--no-starship")
      STARSHIP=false
      shift
      ;;
    "--no-greetd")
      LOGIN_MANAGER=false
      shift
      ;;
    "--no-pacman-conf")
      PACMAN=false
      shift
      ;;
    "--no-downloads")
      SKIP_DOWNLOADS=true
      shift
      ;;
    "--no-aur-downloads")
      SKIP_AUR=true
      shift
      ;;
    "--no-gpu-drivers")
      SKIP_GPU_DRIVERS=true
      shift
      ;;
    "--no-gpu-config")
      SKIP_GPU=true
      shift
      ;;
    "--no-gtk")
      config_dirs[gtk-3.0]=false
      config_dirs[gtk-4.0]=false
      shift
      ;;
    "--no-qt")
      config_dirs[qt5ct]=false
      config_dirs[qt6ct]=false
      shift
      ;;
    "--replace-dm")
      REPLACE_DM=true
      shift
      ;;
    "--help" | "-h")
      help_menu
      exit 0
      ;;
    *)
      error "Unknow flag: $1 " "Use --help or -h to see the available options."
      exit 1
      ;;
    esac
  done
}

#######
# Configure /etc/pacman.conf, enabling features like parallel downloads and the ILoveCandy easter egg.
#
# Requires:
#   Active sudo privileges. The caller must ensure the user is already authenticated
#   (e.g., by running `sudo -v` beforehand) as this function does not prompt for a password.
#
# Returns:
#   1 - If sudo privileges are missing/expired.
#######
setup_pacman_conf() {
  if ! sudo -n true 2>/dev/null; then
    error "Sudo privileges missing or expired. Cannot configure pacman.conf."
    return 1
  fi

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
}

#######
# Backups the specified directory or file to the location specified in the $BACKUP_DIR global variable.
#
# Creates $BACKUP_DIR if it doesn't exists.
#
# Arguments:
#   $1 - The directory/file to backup
#######
backup_dir() {
  if ! [ -d "$BACKUP_DIR" ]; then
    dry_run mkdir -p "$BACKUP_DIR"
  fi

  if [ -e "$1" ]; then
    dry_run mv "$1" "$BACKUP_DIR"
  else
    dry_run error "Fail to backup '$1'. It doesn't exists. Skipping..."
  fi
}

#######
# Symlinks each directory in the repo's own .config/ to user's ~/.config/
#
# Relies on backup_dir function to make the backup before perform the symlinking.
#######
symlink_config_dirs() {
  dry_run printf "\n%s\n" "Symlinking configuration directories..."

  if ! [ -d "$HOME/.config" ]; then
    dry_run mkdir -p "$HOME/.config"
  fi

  for dir in "${!config_dirs[@]}"; do
    if [ "${config_dirs[$dir]}" = false ]; then
      continue
    fi

    SOURCE="$DOTFILES_PATH/.config/$dir"
    TARGET="$HOME/.config/$dir"

    if [ -d "$SOURCE" ]; then
      backup_dir "$TARGET"

      dry_run ln -snf "$SOURCE" "$TARGET"
      dry_run success "Linked: $SOURCE -> $TARGET"

    else
      dry_run error "Directory '$dir' not found in '$DOTFILES_PATH'. Skipping..."
    fi
  done
}

#######
# Symlinks the starship.toml file in the repo's own .config/ to user's ~/.config/
#
# Relies on backup_dir function to make the backup before perform the symlinking.
#######
symlink_starship_config_file() {
  dry_run printf "\n%s\n" "Symlinking starship configuration file (starship.toml)..."

  backup_dir "$HOME/.config/starship.toml"
  dry_run ln -snf "$DOTFILES_PATH/.config/starship.toml" "$HOME/.config/starship.toml"

  dry_run success "Linked file: starship.toml"
}

#######
# Sets up the Greetd display manager (a.k.a login manager).
#
# Applies the new configurations and back up the old ones if greetd is already active.
# Automatically enables greetd if there is no other login manager.
#
# Arguments:
#   $1 - Boolean ('true' or 'false'). If 'true' and there is other DM enable, replaces it with Greetd.
#
# Requires:
#   Active sudo privileges. The caller must ensure the user is already authenticated
#   (e.g., by running `sudo -v` beforehand) as this function does not prompt for a password.
#
# Returns:
#   1 - If sudo privileges are missing/expired.
#   2 - If a different display manager is currently active and replacement was not requested.
######
configure_login_manager() {
  if ! sudo -n true 2>/dev/null; then
    return 1
  fi

  local DM_NAME=""
  if systemctl is-active --quiet display-manager.service; then
    DM_NAME=$(basename "$(readlink /etc/systemd/system/display-manager.service)" | sed 's/.service//')
  fi

  if [ -z "$DM_NAME" ]; then
    dry_run info "No enabled login manager was found. Activating Greetd..."

    if [ -d "/etc/greetd" ] || [ -L "/etc/greetd" ]; then
      dry_run sudo mv /etc/greetd "$BACKUP_DIR/"
    fi

    dry_run sudo ln -snf "$DOTFILES_PATH/greetd" "/etc/greetd"

    dry_run sudo systemctl enable greetd.service
    dry_run success "The login manager Greetd with Tuigreet has been enabled!"

  elif [ "$DM_NAME" = "greetd" ]; then
    dry_run info "Aplying new configurations to Greetd..."

    if [ -d "/etc/greetd" ] || [ -L "/etc/greetd" ]; then
      dry_run sudo mv /etc/greetd "$BACKUP_DIR/"
    fi

    dry_run sudo ln -snf "$DOTFILES_PATH/greetd" "/etc/greetd"

  else
    local REPLACE_DM="$1"
    if [ "$REPLACE_DM" = "true" ]; then
      dry_run sudo ln -snf "$DOTFILES_PATH/greetd" "/etc/greetd"

      dry_run sudo systemctl disable "$DM_NAME"
      dry_run sudo systemctl enable greetd.service

      dry_run success "$DM_NAME disabled and Greetd enabled!"
    else
      dry_run warn "Unable to configure Greetd. $DM_NAME is already active."
      return 2
    fi
  fi
}

customize_icons() {
  dry_run printf "%s\n" "Customizing icons with Catppuccin Mocha..."

  if command -v papirus-folders &>/dev/null; then
    dry_run papirus-folders -C cat-mocha-flamingo --theme Papirus-Dark
  else
    dry_run warn "Package papirus-folders not founded. Verify the installation."
  fi
}

parse_cli_args "$@"

printf "%b%s%b\n" "$BLUE" "Starting Arch Linux rice setup..." "$NO_COLOR"

if $DRY_RUN_MODE; then
  printf "\n%b%s\n" "$YELLOW" "--- DRY RUN MODE ACTIVATED ---"
  printf "%s%b\n" "Commands will be printed, but not executed." "$NO_COLOR"

else
  info "This script will create a backup of some configuration directories (if they exist)" \
    "Directories to backup: ${!config_dirs[*]} and greetd" \
    "Backup path: $BACKUP_DIR" \
    "Proceed? [Y/n] "
  read -r confirm

  confirm=$(printf "%s" "$confirm" | tr '[:upper:]' '[:lower:]')

  if [[ "$confirm" == "n" || "$confirm" == "no" ]]; then
    info "Script interrupted by the user."
    exit 1
  fi

  printf "%s\n" "Please enter your password to allow package downloads"
  sudo -v

  while true; do
    sudo -n -v
    sleep 60
    kill -0 "$$" || exit
  done 2>/dev/null &

  if $PACMAN; then
    setup_pacman_conf
  fi

  if ! $SKIP_GPU; then
    SKIP_GPU_DRIVERS="$SKIP_GPU_DRIVERS" ./scripts/gpu-config.sh
  fi
fi

if ! $SKIP_DOWNLOADS; then
  DRY_RUN_MODE="$DRY_RUN_MODE" SKIP_AUR="$SKIP_AUR" ./scripts/package-installation.sh
fi

symlink_config_dirs

customize_icons

if $STARSHIP; then
  symlink_starship_config_file
fi

if $LOGIN_MANAGER; then
  configure_login_manager "$REPLACE_DM"
fi

success "Script executed successfully!" "Reboot your PC and enjoy your Arch Linux with Hyprland!"
