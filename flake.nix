{
  description = "Kevin Cardona's universal dotfiles flake";

  outputs = { self }: {
    zsh = ./zsh;
    tmux = ./tmux/.config/tmux;
    kitty = ./kitty/.config/kitty;
    scripts = ./scripts;
  };
}

