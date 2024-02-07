{
  enable = true;
  nix-direnv.enable = true;
  enableBashIntegration = true;
  enableZshIntegration = true;
  enableNushellIntegration = true;
  config = {
    whitelist = {
      prefix = ["~/git/"];
    };
  };
}
