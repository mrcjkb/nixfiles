{pkgs}: {
  enable = true;
  enableNushellIntegration = true;
  enableZshIntegration = true;
  enableBashIntegration = true;
  plugins = with pkgs.yaziPlugins; {
    inherit
      vcs-files
      mount
      ;
  };
  keymap = {
    mgr.prepend_keymap = [
      {
        on = ["g" "c"];
        run = "plugin vcs-files";
        desc = "Show Git file changes";
      }
      {
        on = "M";
        run = "plugin mount";
        desc = "Manage mounts";
      }
    ];
  };
}
