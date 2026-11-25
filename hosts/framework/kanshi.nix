{defaultUser, ...}: {
  home-manager.users."${defaultUser}" = {
    services.kanshi.enable = true;

    xdg.configFile."kanshi/config".text = ''
      profile undocked {
          output "eDP-1" mode "2560x1600" position 0,0
      }

      profile docked {
          output "Dell Inc. DELL U4021QW *" mode "5120x2160@60" position 0,0
          output "eDP-1" mode "2560x1600" position 0,2160
      }

      profile docked-other {
          output "eDP-1" mode "2560x1600" position 0,2160
          output "*" mode preferred position 0,0
      }
    '';
  };
}
