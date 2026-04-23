# General Settings
export ZSH="$HOME/.oh-my-zsh"
export EDITOR='nvim'
export JAVA_HOME=/opt/homebrew/opt/openjdk@11

# Path Configurations
export PATH=/opt/homebrew/bin:$PATH
export PATH="$HOME/.config/bin/.local/scripts:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
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

PATH="/Users/kcardona/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/kcardona/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/kcardona/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/kcardona/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/kcardona/perl5"; export PERL_MM_OPT;


export PUID=$(id -u)
export PGID=$(id -g)
export TZ="America/Denver"
export DOCKER_SUBNET="172.20.0.0/24"
export DOCKER_GATEWAY="172.20.0.1"


### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/kcardona/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# Added by syseng-k8s-tools installer
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

eval "$(mise activate zsh)"
