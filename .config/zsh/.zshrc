MODULES_PATH="$ZDOTDIR/modules"

source "$MODULES_PATH/options.zsh"
source "$MODULES_PATH/aliases.zsh"
source "$MODULES_PATH/fzf.zsh"
source "$MODULES_PATH/plugins.zsh"

eval "$(zoxide init zsh)"

eval "$(starship init zsh)"

autoload -Uz compinit && compinit

compinit -d "$XDG_CACHE_HOME/zsh"

# Case insensitive
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
