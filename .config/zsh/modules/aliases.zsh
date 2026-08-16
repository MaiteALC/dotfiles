# --- Utilities ---
alias c=clear

alias history='history -i'

alias diff='diff --color=auto'

alias rgrep='rg --color=auto'
# -----------------

# --- Eza (better ls) ---
# Simple listing with icons
alias li='eza --icons'

# Detailed listing
alias ll='eza -lhmU --icons --git --total-size --time-style long-iso'

# Detailed listing including hidden files
alias la='eza -lahmU --icons --git --total-size --time-style long-iso'

# Tree view
alias lt='eza -a --tree --icons --no-git'

# List only files
alias lf='eza -lahmU --icons --only-files --time-style long-iso'
# -----------------------
