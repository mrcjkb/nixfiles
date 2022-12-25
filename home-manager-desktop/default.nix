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
          name = "volantes-material-cursors";
          package = pkgs.volantes-cursors-material;
        };
        # cursorTheme = {
        #   name = "Catpuccin-Mocha-Dark-Cursors";
        #   package = pkgs.unstable.catppuccin-cursors;
        # };
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
