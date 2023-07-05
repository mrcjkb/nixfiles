{
  enable = true;
  histSize = 100000;
  shellInit = ''
    eval "$(zoxide init zsh)" # Must be called at the end
  '';
  promptInit = ''
    eval "$(starship init zsh)"
  '';
  shellAliases = import ./shellAliases.nix;
}
