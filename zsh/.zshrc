# General Settings
export ZSH="$HOME/.oh-my-zsh"

# Skip oh-my-zsh's slow per-shell completion-security audit (compaudit).
# Biggest single zsh-startup win (~40% faster); safe if you trust your comp dirs.
ZSH_DISABLE_COMPFIX=true
export EDITOR='nvim'
export JAVA_HOME=/opt/homebrew/opt/openjdk@11

# Path Configurations
export PATH=/opt/homebrew/bin:$PATH
export PATH="$HOME/.config/bin/.local/scripts:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="/Users/$USER/.rd/bin:$PATH"
export BUN_INSTALL="$HOME/.bun"

# Plugins
plugins=(
  git
  zsh-autosuggestions
  zsh-completions
  zsh-syntax-highlighting
)

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

# zoxide — frecency-ranked cd; also powers sesh's zoxide session results
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

# television shell integration: completions + Ctrl-T (smart autocomplete) and
# Ctrl-R (history) picker. NOTE: this rebinds Ctrl-T / Ctrl-R from fzf to tv.
# Prefer fzf's bindings? Just comment out the next line (fzf is still sourced above).
command -v tv >/dev/null && eval "$(tv init zsh)"

# Conditional Settings
if [ -z "$VSCODE_TERMINAL" ]; then
  export ZSH_TMUX_AUTOSTART=true
fi

if [ -z "$TMUX" ] && [ "$TERM" = "xterm-kitty" ] && [ "$ZSH_TMUX_AUTOSTART" ]; then
  tmux attach || exec tmux new-session && exit;
fi

# Perl local::lib — was hardcoded to /Users/kcardona; now portable + guarded so it
# only loads where ~/perl5 actually exists (no dead PATH entries on other machines).
if [ -d "$HOME/perl5" ]; then
  PATH="$HOME/perl5/bin${PATH:+:${PATH}}"; export PATH;
  PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
  PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
  PERL_MB_OPT="--install_base \"$HOME/perl5\""; export PERL_MB_OPT;
  PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"; export PERL_MM_OPT;
fi


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
