PLUGINS_PATH="/usr/share/zsh/plugins"

if [ -e "$PLUGINS_PATH/zsh-autosuggestions" ]; then
  source "$PLUGINS_PATH/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

#NOTE: keep the syntax-highlight plugin as the last to be loaded to avoid color issues
if [ -e "$PLUGINS_PATH/zsh-syntax-highlighting" ]; then
  source "$PLUGINS_PATH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
