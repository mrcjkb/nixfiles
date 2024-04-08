{pkgs}: {
  package = pkgs.atuin;
  enable = true;
  enableNushellIntegration = true;
  enableZshIntegration = true;
}
