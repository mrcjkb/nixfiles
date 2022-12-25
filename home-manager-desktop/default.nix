{ pkgs, user, userEmail, ... }:
{
  home-manager = {
    users."${user}" = {
      programs = import ./programs { pkgs = pkgs.unstable; inherit user userEmail; };
      gtk = {
        enable = true;
        theme = {
          name = "Materia-dark";
          package = pkgs.unstable.materia-theme;
        };
        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.unstable.papirus-icon-theme;
        };
        cursorTheme = {
          name = "Volantes Material Dark";
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
      home = {
        file.".icons/default".source = "${pkgs.volantes-cursors-material}/share/icons/volantes_cursors";
        pointerCursor = {
          name = "Volantes Material Dark";
          package = pkgs.volantes-cursors-material;
        };
      };
    };
  };
}
