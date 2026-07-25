# ----- XDG Base Directories -----
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
# --------------------------------

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# ----- Default Editor -----
# used by git, crontab, etc.
export EDITOR="nvim"
export VISUAL="nvim"
# --------------------------

export GPG_TTY=$(tty) # Useful to prevent terminal freezes when using GPG.

export MANPAGER="bat -pl man"

export BAT_THEME="Catppuccin-Mocha"
