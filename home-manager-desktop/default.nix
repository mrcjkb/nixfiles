{
  pkgs,
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
        cursorTheme = {
          name = "Volantes Material Dark";
          package = pkgs.volantes-cursors-material;
        };
      };
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
        pointerCursor = {
          name = "Volantes Material Dark";
          package = pkgs.volantes-cursors-material;
        };
      };
      services = import ./services;
    };
    sharedModules = [
      {
        stylix = {
          targets = {
            mako.enable = false;
          };
        };
      }
    ];
  };
}
