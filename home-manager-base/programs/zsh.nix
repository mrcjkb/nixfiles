{pkgs}: {
  enable = true;
  histSize = 100000;
  shellInit = ''
    eval "$(zoxide init zsh)" # Must be called at the end
  '';
  promptInit = ''
    eval "$(starship init zsh)"
  '';
  shellAliases = import ./shellAliases.nix;
  plugins = with pkgs; [
    zsh-vi-mode
    zsh-fzf-tab
    zsh-nix-shell
    # fish-like extensions
    zsh-history-substring-search
    # zsh-autosuggestions
    zsh-syntax-highlighting
    # fish-like extensions
  ];
}
