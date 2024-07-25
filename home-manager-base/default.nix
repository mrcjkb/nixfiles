{
  pkgs,
  user,
  userEmail,
  nu-scripts,
  ...
}: {
  home-manager = {
    users."${user}" = {
      xdg.enable = true;
      programs = import ./programs {
        inherit
          pkgs
          user
          userEmail
          nu-scripts
          ;
      };
      xdg.configFile = {
        bat = {
          source = ./configs/bat/.;
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
