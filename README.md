![Arch Linux](https://img.shields.io/badge/Arch%20Linux-1793D1?logo=arch-linux&logoColor=white)
![Hyprland](https://img.shields.io/badge/Hyprland-33ccff?logo=hyprland&logoColor=white)
![Theme](https://img.shields.io/badge/Theme-Catppuccin%20Mocha-f5e0dc?labelColor=1e1e2e)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)


# Catppuccin Mocha - Hyprland Dotfiles

This repository contains my personal rice, based on Hyprland, focused on Catppuccin Mocha and automated by an installation script.

---

# The Installation Script (install.sh)

The distinguishing feature of this repository is its self-sufficient post installation script. It was projected to be executed in a clean Arch Linux installation, in other words, without DEs (Desktop Environments) like KDE Plasma or GNOME.

*Script features:*

- Hardware Detection: automatic Nvidia GPUs detection to install the appropriated drivers (like nvidia-open-dkms and others).

- Intelligent AUR Helper: Detects yay or paru. If none was found, installs yay automatically.

- Dry-Run Mode: Allows test all the script without alter a single file in your system.

- Symlink Management: make symlinks between the repository and your ~/.config/ folder in a clean way.

- Color Consistency: Applies the Catppuccin Mocha Red in the Papirus Dark icon theme via CLI.

- Wallpaper folder: Provides a set of wallpapers to match the Hyprland style.

---

# Rice Components

| Category | Tool | Description |
| :--- | :--- | :--- |
| **Compositor** | [Hyprland](https://hyprland.org/) | Dinamic windows and fluid animations |
| **Status Bar** | [Waybar](https://github.com/Alexays/Waybar) | Highly customizable status bar |
| **Colors** | [Catppuccin](https://github.com/catppuccin/catppuccin) | Mocha flavor for all the system |
| **App Launcher** | [Wofi](https://wiki.archlinux.org/title/Wofi) | Fast and minimalist app launcher stylized using CSS
| **Notifications** | [SwayNC](https://github.com/ErikReider/SwayNotificationCenter) | Complete notification center
| **Terminal Emulator** | [Kitty](https://sw.kovidgoyal.net/kitty/index.html) | GPU-accelerated terminal emulator
| **Shell** | [Zsh](https://www.zsh.org/) | Modern, powerfull and customazible shell with starship prompt
| **Clipboard** | [Cliphist](https://github.com/sentriz/cliphist) | Minimalist and integrated with Wofi 
| **Wallpapers** | [Hyprpaper](https://wiki.hypr.land/Hypr-Ecosystem/hyprpaper/) |  Native tool from hypr ecossystem


---

# How to install

*Note:* It's a good practice review scripts downloaded from internet before execute them.

*1. Clone the repository:*

```bash
git clone https://github.com/maiteALC/dotfiles.git
cd ~/dotfiles
```

*2. Change the permissions:*

```bash
chmod u+x install.sh
```

*3. Execute the Test (Dru-Run):*

```bash
./install.sh --dry-run
```

*4. Real Execution:*

```bash
./install.sh
```

---

# Main Keybinds:

- Super + Enter = terminal (kitty)

- Super + R = app launcher (wofi)

- Super + V = clipboard history (cliphist/wofi)

- Super + N = notification center (SwayNC)

- Super + L = lock the screen (hyprlock)

- Super + Shift + F = fullscreen

Check the ```./hypr/hyprland.conf``` file to see all keybinds.
