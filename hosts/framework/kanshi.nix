{...}: {
  services.kanshi.enable = true;

  environment.etc."xdg/kanshi/config".text = ''
    profile docked {
        output "eDP-1" mode "2560x1600" position 0,2160
        output "*" mode preferred position 0,0
    }

    profile undocked {
        output "eDP-1" mode "2560x1600" position 0,0
    }
  '';
}
