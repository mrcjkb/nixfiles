{pkgs}: {
  enable = true;
  enableBashIntegration = true;
  enableZshIntegration = true;
  enableNushellIntegration = true;
  settings = {
    character = {
      success_symbol = " ✔(bold green)";
      error_symbol = " ✘(bold red)";
      vicmd_symbol = "[❮](bold green)";
    };
    memory_usage = {disabled = true;};
    custom.jj = let
      jj-starship = pkgs.lib.getExe pkgs.jj-starship;
    in {
      description = "Show Jujutsu info";
      when = "${jj-starship} detect";
      shell = [jj-starship];
      format = "$output ";
    };
    vcs.disabled = true;
    git_branch.disabled = true;
    git_commit.disabled = true;
    nix_shell.format = "'[$symbol $name]($style) '";
  };
}
