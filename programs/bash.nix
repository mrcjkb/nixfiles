{
  enable = true;
  enableCompletion = true;
  shellInit = ''
    zoxide init bash | source
  '';
  promptInit = ''
    starship init bash | source
  '';
  shellAliases = import ./shellAliases.nix;
}
