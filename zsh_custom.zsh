eval "$(starship init zsh)"

setopt EXTENDED_HISTORY
autoload -Uz compinit && compinit

# Ignore case sensitivity
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

alias c=clear
alias history="history -i"

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Note: keep the syntax-highlight plugin as the last to be loaded to avoid color issues
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
