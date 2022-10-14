{ pkgs, user, userEmail, ... }:
{
  home-manager = {
    users."${user}" = {
      xdg.enable = true;
      programs = {
        git = {
          enable = true;
          userName = "Marc Jakobi";
          inherit userEmail;
          signing = {
            key = "F31C0D0D5BBB0289";
          };
          extraConfig = {
            merge = {
              tool = "fugitive";
            };
            mergetool = {
              fugitive = {
                cmd = "${pkgs.neovim}/bin/nvim -f -c \"Gvdiffsplit!\" \"$MERGED\"";
              };
            };
            pull = {
              rebase = true;
            };
            # Force SSH instead of HTTPS:
            # url."ssh://git@github.com/".insteadOf = "https://github.com/";
          };
          ignores = [
            "Session.vim"
            ".hlint.yaml"
          ];
        };
        zoxide = {
          enable = true;
          enableFishIntegration = true;
        };
        starship = {
          enableBashIntegration = true;
          enableFishIntegration = true;
          settings = {
            character = {
              success_symbol = " ✔(green)";
              error_symbol = " ✘(red)";
              use_symbol_for_status = true;
            };
            memory_usage = { disabled = true; };
          };
        };
      };
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
    };
  };
}
