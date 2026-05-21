{pkgs}: {
  enableBashIntegration = true;
  enableZshIntegration = true;
  enableNushellIntegration = true;
  settings = {
    character = {
      success_symbol = " ✔(green)";
      error_symbol = " ✘(red)";
      use_symbol_for_status = true;
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
  };
}
