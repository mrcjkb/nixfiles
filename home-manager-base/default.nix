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
        ranger = {
          source = ./configs/ranger/.;
          recursive = true;
        };
        "ranger/plugins/ranger_devicons" = {
          source = pkgs.fetchFromGitHub {
            owner = "alexanderjeurissen";
            repo = "ranger_devicons";
            rev = "1b5780117eeebdfcd221ce45823a1ddef8399848";
            hash = "sha256-MMPbYXlSLwECf/Li4KqYbSmKZ8n8LfTdkOfZKshJ30w=";
          };
          recursive = true;
        };
        "ranger/plugins/zoxide" = {
          source = pkgs.fetchFromGitHub {
            owner = "jchook";
            repo = "ranger-zoxide";
            rev = "363df97af34c96ea873c5b13b035413f56b12ead";
            hash = "sha256-HFCGuAektrSHF7GJsoKv1TJ/T/dwkYK1eUcw8nEjJII=";
          };
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
