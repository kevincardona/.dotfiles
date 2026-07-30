# Brewfile — CLI tools these dotfiles depend on.
#
# Fresh machine:
#   cd ~/.dotfiles && brew bundle
#   stow zsh tmux kitty television sesh          # symlink the configs
#   tv update-channels                           # pull television's default channels
#
# kubectl / helm / docker come from Rancher Desktop (installed separately), not brew.

# --- core dotfiles machinery ---
brew "stow"        # deploys the dotfiles as symlinks
brew "tmux"        # terminal multiplexer
brew "neovim"      # $EDITOR (config is the nvim/.config/nvim submodule)
brew "mise"        # runtime/version manager (replaced asdf)

# --- television + sesh: session / fuzzy-find stack ---
brew "television"  # `tv` — the fuzzy finder + channels
brew "sesh"        # smart tmux session manager (prefix+f)
brew "zoxide"      # frecency `cd`; powers sesh's zoxide results and `z`
brew "fzf"         # tmux-sessionizer + shell helper functions
brew "fd"          # fast find — backs television's `files` channel
brew "bat"         # syntax-highlighted previews in television

# --- channel / workflow tools ---
brew "jq"          # sw() search helper + JSON wrangling
brew "argocd"      # television argocd-apps channel (run `argocd login` to use)
brew "lazygit"     # `lg`
brew "glab"        # glab-pipelines script (`ci` / `cia`)
brew "trash"       # `del` / `dl` aliases
