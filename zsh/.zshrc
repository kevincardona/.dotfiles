# zmodload zsh/zprof # profiling
export ZSH="$HOME/.oh-my-zsh"
export EDITOR='nvim'
export PATH=/opt/homebrew/bin:$PATH

if [ -z "$VSCODE_TERMINAL" ]; then
  export ZSH_TMUX_AUTOSTART=true
fi 

# robbyrussell, af-magic
ZSH_THEME="af-magic"
DISABLE_UPDATE_PROMPT=true

# plugins
plugins=(
	git
	zsh-autosuggestions
        zsh-completions
	zsh-syntax-highlighting
	emoji
        tmux
)


# Unset the ZSH_HIGHLIGHT_STYLES associative array to reset all styles to their defaults
unset ZSH_HIGHLIGHT_STYLES

typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[comment]='none'

fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

source $ZSH/oh-my-zsh.sh

# keybindings
bindkey -e
bindkey '\e\e[C' forward-word
bindkey '\e\e[D' backward-word

# functions
ccd() {
    local selected=$(find ~ ~/projects ~/.config ~/work ~/work/valert ~/work/telekit ~/work/racc ~/personal -mindepth 1 -maxdepth 1 -type d | fzf)

    if [[ -z $selected ]]; then
        echo "No directory selected."
        return 1
    fi

    # Change to the selected directory
    cd "$selected" || return

    # If inside tmux, update the current pane's directory
    if [[ -n $TMUX ]]; then
        tmux send-keys "cd $selected" C-m
    fi
}

menubar() {
    currentState=$(defaults read NSGlobalDomain _HIHideMenuBar)
    if [ "$currentState" -eq 1 ]; then
        defaults write NSGlobalDomain _HIHideMenuBar -bool false
    else
        defaults write NSGlobalDomain _HIHideMenuBar -bool true
    fi
    killall Finder
}

gcobr() {
    git checkout -b $1/RACCWEB-$2
}

tmuxfzf() {
  local initial_query="$1"
  # Get the list of projects, excluding the first line
  local projects=$(tmuxinator list | sed 1d | awk '{for(i=1;i<=NF;i++) if($i ~ /^[[:alnum:]_\-]+$/) print $i}')
  
  # Filter projects based on the initial query, if provided
  local filtered_projects=""
  if [[ -n "$initial_query" ]]; then
    filtered_projects=$(echo "$projects" | grep -i "$initial_query")
  else
    filtered_projects="$projects"
  fi

  # Count the number of matching projects
  local count=$(echo "$filtered_projects" | wc -l | xargs)
  
  # If exactly one match is found, start it directly
  if [ "$count" -eq 1 ]; then
    tmuxinator start "$(echo "$filtered_projects")"
  else
    # Otherwise, use fzf to select the project
    echo "$filtered_projects" | fzf --height 40% --border rounded --query="$initial_query" | xargs tmuxinator start
  fi
}

# Function to open JIRA ticket from the branch name
ticket() {
  # Get the current branch name
  local branch_name=$(git rev-parse --abbrev-ref HEAD)

  # Extract the ticket number (e.g., RACCWEB-18579) from the branch name
  if [[ $branch_name =~ ([A-Z]+-[0-9]+) ]]; then
    local ticket_number=${match[1]}
    # Construct the JIRA URL
    local jira_url="https://vailsys.atlassian.net/browse/$ticket_number"
    # Open the URL in the default web browser
    open $jira_url
  else
    echo "No JIRA ticket number found in the branch name."
  fi
}

lazy_load() {
    local -a names
    if [[ -n "$ZSH_VERSION" ]]; then
        names=("${(@s: :)${1}}")
    else
        names=($1)
    fi
    unalias "${names[@]}"
    . $2
    shift 2
    $*
}

group_lazy_load() {
    local script
    script=$1
    shift 1
    for cmd in "$@"; do
        alias $cmd="lazy_load \"$*\" $script $cmd"
    done
}

# Connect or disconnect AirPods
ap() {
    if ! type "blueutil" > /dev/null; then
        brew install blueutil
    fi
    if blueutil --paired | grep -q "10-b5-88-9e-34-81, connected"; then
        echo "AirPods are connected. Disconnecting..."
        blueutil --disconnect 10-b5-88-9e-34-81
    else
        echo "Connecting AirPods..."
        blueutil --connect 10-b5-88-9e-34-81
        if [ $? -ne 0 ]; then
            echo "Failed to connect AirPods."
            return 1
        fi
        echo "AirPods connected."
    fi
}

function spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

function fzf-insert-last-command-output() {
    local last_command=$(fc -ln -1 | head -n 1)
    echo -e "\n\e[33mAre you sure you want to rerun '$last_command'? (y/n): \e[0m"
    read -k 1 reply
    echo  # Move to a new line after the input

    if [[ "$reply" =~ ^[Yy]$ ]]
    then
        (eval "$last_command" > /tmp/command_output.txt 2>&1) & 
        local cmd_pid=$!
        spinner $cmd_pid
        wait $cmd_pid
        local command_output=$(cat /tmp/command_output.txt)
        if [[ -z "$command_output" ]]; then
            echo "The command did not produce any output."
            return
        fi
        local selected_output=$(echo "$command_output" | tr ' ' '\n' | grep -v '^\s*$' | fzf --height 40% --reverse)
        if [[ -n $selected_output ]]; then
            LBUFFER+="$selected_output "
        fi
        zle reset-prompt
        zle -R
    else
        echo "Command execution canceled."
    fi
}
zle -N fzf-insert-last-command-output
bindkey '^O' fzf-insert-last-command-output

search_k8s_logs() {
  local search_term="$1"
  local timeout_duration="${2:-3s}" # Default timeout duration is 60 seconds if not provided

  if [[ -z "$search_term" ]]; then
    echo "Usage: search_k8s_logs <search_term> [timeout_duration]"
    return 1
  fi

  echo "Searching logs in sf-test context for term: $search_term with timeout: $timeout_duration"
  timeout "$timeout_duration" stern --context sf-test $search_term --since 8h

  echo "Searching logs in au-test context for term: $search_term with timeout: $timeout_duration"
  timeout "$timeout_duration" stern --context au-test $search_term --since 1h
}

kcl() {
  if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    echo "Usage: kcl <deployment> [container]"
    return 1
  fi

  DEPLOYMENT=$1
  CONTAINER_NAME=${2:-}  # Optional container name
  CONTEXTS=("sf-test" "au-test")

  # Save the current context
  ORIGINAL_CONTEXT=$(kubectl config current-context)

  # Capture output in a variable
  OUTPUT=""

  for CONTEXT in "${CONTEXTS[@]}"; do
    OUTPUT+=$'\n'"Switching to context $CONTEXT"
    kubectl config use-context "$CONTEXT" &> /dev/null

    # Get all pods in the deployment and store them in an array
    PODS=($(kubectl get pods --selector=app.kubernetes.io/name="$DEPLOYMENT" --output=jsonpath='{.items[*].metadata.name}'))

    if [ ${#PODS[@]} -eq 0 ]; then
      OUTPUT+=$'\n'"No pods found for deployment $DEPLOYMENT in context $CONTEXT"
      continue
    fi

    # Display logs for specified container or all containers in all pods in the deployment
    for POD in "${PODS[@]}"; do
      if [ -n "$CONTAINER_NAME" ]; then
        OUTPUT+=$'\n'"Logs for pod $POD, container $CONTAINER_NAME in context $CONTEXT:"
        OUTPUT+=$'\n'"$(kubectl logs "$POD" -c "$CONTAINER_NAME")"
        OUTPUT+=$'\n'"----------------------------------------------------------------"
      else
        CONTAINERS=($(kubectl get pod "$POD" --output=jsonpath='{.spec.containers[*].name}'))
        for CONTAINER in "${CONTAINERS[@]}"; do
          OUTPUT+=$'\n'"Logs for pod $POD, container $CONTAINER in context $CONTEXT:"
          OUTPUT+=$'\n'"$(kubectl logs "$POD" -c "$CONTAINER")"
          OUTPUT+=$'\n'"----------------------------------------------------------------"
        done
      fi
    done
  done

  # Switch back to the original context
  OUTPUT+=$'\n'"Switching back to original context $ORIGINAL_CONTEXT"
  kubectl config use-context "$ORIGINAL_CONTEXT" &> /dev/null

  # Print the output to less
  echo "$OUTPUT" | less -R
}

# aliases
alias darkmode="osascript -e 'tell app \"System Events\" to tell appearance preferences to set dark mode to not dark mode'"
alias python="python3"
alias vim="nvim"
alias clear="clear && tmux clear-history"
alias vsc="cd ~/.config/scripts && python vsc.py"
alias log-sf-test='stern --context sf-test'
alias log-au-test='stern --context au-test'
alias del='trash'
alias bers="bundle exec rails s"
alias bera="bundle exec rubocop -a"
alias beks="bundle exec karafka s"
alias lg="lazygit"
alias dl="trash"
alias kc="kubectl"
alias kcs="kubectl --context=sf-test"
alias kca="kubectl --context=au-test"
alias kcgp="kubectl get pods"
alias kctl="kubectl"
alias gl='git pull'
alias gp='git push'
alias gs='git status'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gd='git diff'
alias ga='git add'
alias gc='git commit'
alias gcm='git commit -m'

# dependencies
export PATH=$(pyenv root)/shims:$PATH

# Less Syntax Highlighting:
LESSPIPE=`which src-hilite-lesspipe.sh`
export LESSOPEN="| ${LESSPIPE} %s"
export LESS=' -R -X -F '

# NVM Configuration
lazy_load_nvm() {
  unset -f node nvm
  export NVM_DIR=~/.nvm
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
}

node() {
  lazy_load_nvm
  node $@
}

nvm() {
  lazy_load_nvm
  node $@
}


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[ -s "/Users/$USER/.bun/_bun" ] && source "/Users/$USER/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export JAVA_HOME=/opt/homebrew/opt/openjdk@11
export PATH=$HOME/development/sdks/flutter/bin:$PATH 

export PATH=$HOME/.gem/bin:$PATH

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/$USER/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# add local scripts to path
export PATH="$HOME/.config/bin/.local/scripts:$PATH"

# You may need to add this to your ~/.zshrc file to make sure that the PATH is set correctly
# export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to path for scripting (to manage Ruby versions)
# export PATH="$GEM_HOME/bin:$PATH"
# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"  # Load RVM into a shell session *as a function*

# zprof # profiling - end
