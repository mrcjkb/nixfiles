{pkgs}: {
  enable = true;
  enableNushellIntegration = true;
  enableZshIntegration = true;
  enableBashIntegration = true;
  plugins = with pkgs.yaziPlugins; {
    inherit
      mount
      starship
      vcs-files
      ;
  };
  initLua =
    # lua
    ''
      require("starship"):setup {
        hide_flags = true,
      }
    '';
  keymap = {
    mgr.prepend_keymap = [
      {
        on = "M";
        run = "plugin mount";
        desc = "Manage mounts";
      }
      {
        on = ["g" "c"];
        run = "plugin vcs-files";
        desc = "Show Git file changes";
      }
    ];
  };
}
