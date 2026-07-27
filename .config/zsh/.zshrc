MODULES_PATH="$ZDOTDIR/modules"

source "$MODULES_PATH/options.zsh"
source "$MODULES_PATH/aliases.zsh"
source "$MODULES_PATH/fzf.zsh"
source "$MODULES_PATH/plugins.zsh"

eval "$(zoxide init zsh)"

eval "$(starship init zsh)"

mkdir -p "$XDG_CACHE_HOME/zsh"

autoload -Uz compinit && compinit
compinit -d "$XDG_CACHE_HOME/zsh/.zcompdump"

# Case insensitive
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

export GPG_TTY=$(tty) # Useful to prevent terminal freezes when using GPG.

export MANPAGER="bat -pl man"

export BAT_THEME="Catppuccin-Mocha"
