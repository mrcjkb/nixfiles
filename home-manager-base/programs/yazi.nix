{pkgs}: {
  enable = true;
  enableNushellIntegration = true;
  enableZshIntegration = true;
  enableBashIntegration = true;
  plugins = with pkgs.yaziPlugins; {
    inherit
      diff
      git
      relative-motions
      mount
      smart-paste
      starship
      vcs-files
      ;
  };
  initLua =
    # lua
    ''
      require('git').setup {
        order = 1500,
      }
      require('relative-motions'):setup {
        show_numbers = 'relative',
      }
      require('starship'):setup {
        hide_flags = true,
      }
    '';
  settings = {
    plugin.prepend_fetchers = [
      {
        id = "git";
        url = "*";
        run = "git";
      }
      {
        id = "git";
        url = "*/";
        run = "git";
      }
    ];
  };
  keymap = {
    mgr.prepend_keymap = [
      {
        on = "<C-d>";
        run = "plugin diff";
        desc = "Diff the selected with the hovered file";
      }
      {
        on = "m";
        run = "plugin relative-motions";
        desc = "Trigger a new relative motion";
      }
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
