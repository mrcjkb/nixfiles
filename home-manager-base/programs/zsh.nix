{pkgs}: {
  enable = true;
  history = {
    size = 100000;
  };
  initExtra = ''
    . ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    eval "$(zoxide init zsh)" # Must be called at the end
    eval "$(starship init zsh)"
    eval "$(direnv hook zsh)"
  '';
  shellAliases = import ./shellAliases.nix;
  # FIXME:
  # plugins = with pkgs; [
  #   zsh-vi-mode
  #   zsh-fzf-tab
  #   zsh-nix-shell
  #   # fish-like extensions
  #   zsh-history-substring-search
  #   # zsh-autosuggestions
  #   # fish-like extensions
  # ];
}
