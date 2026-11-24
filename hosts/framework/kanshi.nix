{
  defaultUser,
  lib,
  ...
}: let
  dockedPorts = ["DP-5" "DP-6" "DP-7" "DP-8"];

  dockedProfile = port: ''
    profile docked-${port} {
        output "${port}" mode "5120x2160" position 0,0
        output "eDP-1" mode "2560x1600" position 0,2160
    }

  '';
in {
  home-manager.users."${defaultUser}" = {
    services.kanshi.enable = true;

    xdg.configFile."kanshi/config".text = ''
      profile undocked {
          output "eDP-1" mode "2560x1600" position 0,0
      }

      ${lib.concatMapStrings dockedProfile dockedPorts}profile docked-other {
          output "eDP-1" mode "2560x1600" position 0,2160
          output "*" mode preferred position 0,0
      }
    '';
  };
}
