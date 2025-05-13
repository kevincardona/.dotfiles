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

# Misc Environment Variables
export ASDF_NODEJS_LEGACY_FILE_DYNAMIC_STRATEGY=latest_available

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
if [ -f "$ZSH/oh-my-zsh.sh" ]; then
  source "$ZSH/oh-my-zsh.sh"
fi

# Custom Functions
source ~/.zsh_functions

# Work Configuration
if [[ -f ~/.zsh_work ]]; then
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

if [ -z "$TMUX" ] && [ "$TERM" = "xterm-kitty" ] && [ "$ZSH_TMUX_AUTOSTART" ]; then
  tmux attach || exec tmux new-session && exit;
fi


### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/kcardona/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
