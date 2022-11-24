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
      xdg.configFile = {
        bat = {
          source = ./configs/bat/.;
          recursive = true;
        };
        keepassxc = {
          source = ./configs/keepassxc/.;
          recursive = true;
        };
        ranger = {
          source = ./configs/ranger/.;
          recursive = true;
        };
        joplin = {
          source = ./configs/joplin/.;
          recursive = true;
        };
      };
      home.file = {
        ".yubico" = {
          source = ./configs/.yubico/.;
          recursive = true;
        };
        ".direnvrc" = {
          text = ''
            source /run/current-system/sw/share/nix-direnv/direnvrc
          '';
        };
      };
    };
  };
}
