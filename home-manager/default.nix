{ pkgs, user, userEmail, ... }:
{
  home-manager = {
    users."${user}" = {
      xdg.enable = true;
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
      xdg.configFile."Yubico/Yubico Authenticator.conf" = ./configs/Yubico/Yubico_Authenticator.conf;
    };
  };
}
