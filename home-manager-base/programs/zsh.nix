{pkgs}: {
  enable = true;
  history = {
    size = 100000;
  };
  initExtra = ''
    . ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source ${pkgs.zsh-nix-shell}/nix-shell.plugin.zsh
    eval "$(zoxide init zsh)" # Must be called at the end
    eval "$(starship init zsh)"
    eval "$(direnv hook zsh)"
  '';
  # TODO: Move
  shellAliases = import ../../programs/shellAliases.nix;
  zplug = {
    enable = true;
    plugins = [
      {name = "zsh-users/zsh-autosuggestions";}
      {name = "jeffreytse/zsh-vi-mode";}
      {name = "zsh-users/zsh-history-substring-search";}
    ];
  };
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
