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
      xdg.configFile."Yubico" = {
        source = ./configs/Yubico/.;
        recursive = true;
      };
      xdg.configFile."bat" = {
        source = ./configs/bat/.;
        recursive = true;
      };
      xdg.configFile."keepassxc" = {
        source = ./configs/keepassxc/.;
        recursive = true;
      };
      xdg.configFile."rofi" = {
        source = ./configs/rofi/.;
        recursive = true;
      };
    };
  };
}
