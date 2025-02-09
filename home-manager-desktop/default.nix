{
  pkgs,
  lib,
  user,
  userEmail,
  ...
}: {
  home-manager = {
    users."${user}" = {
      programs = import ./programs {
        inherit pkgs user userEmail;
      };
      gtk = {
        enable = true;
        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.papirus-icon-theme;
        };
      };
      # qt.platformTheme = lib.mkForce "gtk3";
      xdg.configFile = {
        keepassxc = {
          source = ./configs/keepassxc/.;
          recursive = true;
        };
        Yubico = {
          source = ./configs/Yubico/.;
          recursive = true;
        };
        joplin-desktop = {
          source = ./configs/joplin-desktop/.;
          recursive = true;
        };
      };
      home = {
        file.".icons/default".source = "${pkgs.volantes-cursors-material}/share/icons/volantes_cursors";
      };
      services = import ./services;
    };
    sharedModules = [
      {
        stylix = {
          # NOTE: If a target does not exist, it belongs in desktop.nix
          targets = {
            mako.enable = false;
            kde.enable = false;
          };
        };
      }
    ];
  };
}
