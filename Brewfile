# Brewfile — CLI tools these dotfiles depend on.
#
# Fresh machine:  cd ~/.dotfiles && make      (runs everything — see the Makefile)
# Just the packages:  brew bundle
#
# kubectl / helm / docker come from Rancher Desktop (installed separately), not brew.

# --- core dotfiles machinery ---
brew "stow"        # deploys the dotfiles as symlinks
brew "tmux"        # terminal multiplexer
brew "neovim"      # $EDITOR (config is the nvim/.config/nvim submodule)
brew "mise"        # runtime/version manager (replaced asdf)

# --- television: fuzzy-find + channels ---
brew "television"  # `tv` — the fuzzy finder + channels (tmux-sessionizer pipes into it)
brew "fzf"         # shell helper functions (ctrl-o, gw, cds, …)
brew "zoxide"      # frecency `cd` — the `z` command (optional; not used by sessionizer)
brew "fd"          # fast find — backs television's `files` channel
brew "bat"         # syntax-highlighted previews in television

# --- channel / workflow tools ---
brew "jq"          # sw() search helper + JSON wrangling
brew "argocd"      # television argocd-apps channel (run `argocd login` to use)
brew "lazygit"     # `lg`
brew "glab"        # glab-pipelines script (`ci` / `cia`)
brew "trash"       # `del` / `dl` aliases
