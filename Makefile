# Makefile — bootstrap these dotfiles on a new machine.
#
#   git clone --recurse-submodules <repo> ~/.dotfiles
#   cd ~/.dotfiles && make
#
# Every step is also its own target:  make brew | stow | omz | fzf | tpm | tv
# Re-runnable / idempotent. `stow` uses --adopt so pre-existing config files
# don't block it; anything it overwrites is saved to `git stash` (recoverable).
# Written for stock macOS GNU Make 3.81 (no .ONESHELL).

SHELL := bash
.DEFAULT_GOAL := install

DOTDIR      := $(CURDIR)
PACKAGES    := zsh tmux kitty television karabiner nvim scripts
OMZ         := $(HOME)/.oh-my-zsh
OMZ_PLUGINS := zsh-users/zsh-autosuggestions zsh-users/zsh-completions zsh-users/zsh-syntax-highlighting

.PHONY: install all brew submodules dirs stow unstow omz fzf tpm tv help

## install: run the whole bootstrap (default)
install: brew submodules omz dirs stow fzf tpm tv
	@echo ""
	@echo "Bootstrap complete. Open a new terminal (or run: exec zsh)."
	@echo "Try:  prefix+f (projects) | prefix+K (k8s) | tv list-channels"

all: install

## brew: install CLI dependencies from the Brewfile
brew:
	@command -v brew >/dev/null || { echo "Homebrew required first: https://brew.sh"; exit 1; }
	brew bundle --file="$(DOTDIR)/Brewfile"

## submodules: pull the nvim config (and any other submodules)
submodules:
	@git -C "$(DOTDIR)" submodule update --init --recursive

## dirs: pre-create dirs that must stay real (so tools/stow never write into the repo)
dirs:
	@mkdir -p "$(HOME)/.config/television/cable" "$(HOME)/.local/bin"

## stow: symlink all packages (adopts pre-existing files; stashes what it overwrites)
stow: dirs
	@set -e; \
	if git -C "$(DOTDIR)" diff --quiet && git -C "$(DOTDIR)" diff --cached --quiet; then CLEAN=1; else CLEAN=; fi; \
	stow -v --adopt -d "$(DOTDIR)" -t "$(HOME)" $(PACKAGES); \
	if [ -n "$$CLEAN" ] && ! { git -C "$(DOTDIR)" diff --quiet && git -C "$(DOTDIR)" diff --cached --quiet; }; then \
		git -C "$(DOTDIR)" stash push -m "bootstrap: adopted pre-existing configs on $$(hostname)"; \
		echo ">> Pre-existing configs were adopted; the replaced versions are in 'git stash'."; \
		echo "   Repo versions are active now. Recover yours with: git stash show -p stash@{0}"; \
	fi

## unstow: remove all the symlinks this Makefile created
unstow:
	@stow -v -D -d "$(DOTDIR)" -t "$(HOME)" $(PACKAGES)

## omz: install oh-my-zsh + the custom plugins (keeps the stowed .zshrc)
omz:
	@if [ ! -d "$(OMZ)" ]; then \
		RUNZSH=no KEEP_ZSHRC=yes sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; \
	fi
	@for repo in $(OMZ_PLUGINS); do \
		dest="$(OMZ)/custom/plugins/$$(basename $$repo)"; \
		[ -d "$$dest" ] || git clone --depth=1 "https://github.com/$$repo" "$$dest"; \
	done

## fzf: install fzf's shell key-bindings + completion (~/.fzf.zsh), without editing .zshrc
fzf:
	@"$$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc

## tpm: install the tmux plugin manager + its plugins
tpm:
	@[ -d "$(HOME)/.tmux/plugins/tpm" ] || git clone --depth=1 https://github.com/tmux-plugins/tpm "$(HOME)/.tmux/plugins/tpm"
	@"$(HOME)/.tmux/plugins/tpm/bin/install_plugins" || true

## tv: pull television's default channels + seed the k8s-targets file
tv:
	@command -v tv >/dev/null && tv update-channels || true
	@[ -f "$(HOME)/.config/television/k8s-targets" ] || cp "$(DOTDIR)/television/.config/television/k8s-targets.example" "$(HOME)/.config/television/k8s-targets"

## help: list the available targets
help:
	@echo "Targets (make <target>):"
	@grep -E '^## ' $(MAKEFILE_LIST) | sed -E 's/^## /  /'
