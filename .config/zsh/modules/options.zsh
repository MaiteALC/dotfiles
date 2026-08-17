# ----- History -----
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt EXTENDED_HISTORY
# -------------------

# ----- Shell Behaviour -----
setopt NOBEEP
setopt NUMERIC_GLOB_SORT
# --------------------------
