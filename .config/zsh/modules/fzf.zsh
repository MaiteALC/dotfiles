# Fzf configuration and customization

export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix'

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Catppuccin Mocha colors (https://github.com/catppuccin/fzf)
FZF_COLORS="
  --color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8
  --color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC
  --color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8
  --color=selected-bg:#45475A
  --color=border:#6C7086,label:#CDD6F4
"

# Compact UI
export FZF_DEFAULT_OPTS="
  --height 40%
  --layout=reverse
  --border
  $FZF_COLORS
  --preview 'bat --style=numbers --color=always {}'
"

if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
  source /usr/share/fzf/key-bindings.zsh
  source /usr/share/fzf/completion.zsh
fi

_fzf_file_no_hidden() {
  local cmd result

  cmd="${FZF_DEFAULT_COMMAND/--hidden /}"
  result=$(eval "${cmd:-find . -type f}" | fzf ) && LBUFFER+="$result"

  zle reset-prompt
}

zle -N _fzf_file_no_hidden
