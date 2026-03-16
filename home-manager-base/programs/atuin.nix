{pkgs}: {
  package = pkgs.atuin;
  enable = true;
  enableNushellIntegration = false; # This is defined in ./nushell.nix
  enableZshIntegration = true;
}
