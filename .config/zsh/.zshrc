MODULES_PATH="$ZDOTDIR/modules"

source "$MODULES_PATH/options.zsh"
source "$MODULES_PATH/aliases.zsh"
source "$MODULES_PATH/fzf.zsh"
source "$MODULES_PATH/plugins.zsh"

eval "$(zoxide init zsh)"

eval "$(starship init zsh)"

mkdir -p "$XDG_CACHE_HOME/zsh"

autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/.zcompdump"

# Case insensitive
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

export GPG_TTY=$(tty) # Useful to prevent terminal freezes when using GPG.

export MANPAGER="bat -pl man"

export BAT_THEME="Catppuccin-Mocha"

#INFO: The following scripts will be loaded only if they exist.
# Node.js (and consequently, NVM) are dependencies for 'bash_ls', used by Neovim.
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Loads NVM
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # Loads the auto completion
