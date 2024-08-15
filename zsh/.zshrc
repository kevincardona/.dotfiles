# General Settings
export ZSH="$HOME/.oh-my-zsh"
export EDITOR='nvim'
export JAVA_HOME=/opt/homebrew/opt/openjdk@11

# Path Configurations
export PATH=/opt/homebrew/bin:$PATH
export PATH="$HOME/.config/bin/.local/scripts:$PATH"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="/Users/$USER/.rd/bin:$PATH"
export BUN_INSTALL="$HOME/.bun"

# Plugins
plugins=(
  git
  asdf
  zsh-autosuggestions
  zsh-completions
  zsh-syntax-highlighting
)

zstyle ':omz:plugins:zsh-autosuggestions' lazy yes
zstyle ':omz:plugins:zsh-completions' lazy yes
zstyle ':omz:plugins:zsh-syntax-highlighting' lazy yes

# Theme
ZSH_THEME="af-magic"
unset ZSH_HIGHLIGHT_STYLES
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[comment]='none'

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Custom Functions
source ~/.zsh_functions

# Work Configuration
if [[ -f ~/.zsh_work ]]; then
    echo "Have fun working!"
    source ~/.zsh_work
fi

# Aliases
source ~/.zsh_aliases

# Dependencies
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -s "/Users/$USER/.bun/_bun" ] && source "/Users/$USER/.bun/_bun"

# Conditional Settings
if [ -z "$VSCODE_TERMINAL" ]; then
  export ZSH_TMUX_AUTOSTART=true
fi

