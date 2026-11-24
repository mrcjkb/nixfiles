{...}: {
  programs.mergiraf = {
    enable = true;
    enableGitIntegration = false;
    enableJujutsuIntegration = true;
  };
}
