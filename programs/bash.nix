{
  enableCompletion = true;
  interactiveShellInit = ''
    eval "$(zoxide init bash)"
  '';
  promptInit = ''
    eval "$(starship init bash)"
  '';
  shellAliases = import ./shellAliases.nix;
}
