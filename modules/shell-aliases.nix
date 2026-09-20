{...}: {
  nixos.modules.shell-aliases = {...}: {
    programs.bash.shellAliases = import ../data/shellAliases.nix;
  };

  homeManager.modules.shell-aliases = {...}: {
    programs.zsh.shellAliases = import ../data/shellAliases.nix;
  };
}
