{ pkgs, user, userEmail, ... }:
{
  home-manager = {
    users."${user}" = {
      programs = import ./programs { inherit pkgs user userEmail; };
      gtk = {
        enable = true;
        theme = {
          name = "Materia-dark";
          package = pkgs.materia-theme;
        };
        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.papirus-icon-theme;
        };
        cursorTheme = {
          name = "Volantes Material Cursors";
          package = pkgs.volantes-cursors-material;
        };
      };
      xdg.configFile = {
        Yubico = {
          source = ./configs/Yubico/.;
          recursive = true;
        };
        joplin-desktop = {
          source = ./configs/joplin-desktop/.;
          recursive = true;
        };
      };
    };
  };
}
