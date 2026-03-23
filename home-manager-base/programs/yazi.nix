{pkgs}: {
  enable = true;
  enableNushellIntegration = true;
  enableZshIntegration = true;
  enableBashIntegration = true;
  plugins = with pkgs.yaziPlugins; {
    inherit
      mount
      smart-paste
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
        on = "p";
        run = "plugin smart-paste";
        desc = "Paste into the hovered directory or CWD";
      }
      {
        on = ["g" "c"];
        run = "plugin vcs-files";
        desc = "Show Git file changes";
      }
    ];
  };
}
