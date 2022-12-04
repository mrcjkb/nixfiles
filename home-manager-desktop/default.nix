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
      };
      xdg.configFile = {
        Yubico = {
          source = ./home-manager/configs/Yubico/.;
          recursive = true;
        };
        joplin-desktop = {
          source = ./home-manager/configs/joplin-desktop/.;
          recursive = true;
        };
      };
    };
  };
}
