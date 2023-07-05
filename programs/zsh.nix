config: {
  enable = true;
  histSize = 100000;
  histFile = "${config.xdg.dataHome}/zsh/history";
  shellInit = ''
    eval "$(zoxide init zsh)" # Must be called at the end
  '';
  promptInit = ''
    eval "$(starship init zsh)"
  '';
  shellAliases = import ./shellAliases.nix;
}
