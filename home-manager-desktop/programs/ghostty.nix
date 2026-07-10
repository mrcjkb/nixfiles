package: {
  inherit package;
  enable = true;
  installVimSyntax = true;
  enableBashIntegration = true;
  enableZshIntegration = true;
  settings = {
    cursor-style = "block_hollow";
    window-decoration = "none";
  };
}
