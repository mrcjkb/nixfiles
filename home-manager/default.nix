{ user, userEmail, neovim, unstable }:
{
  home-manager = {
    users."${user}" = {
      programs = {
        git = {
          enable = true;
          userName = "Marc Jakobi";
          inherit userEmail;
          signing = {
            key = "F31C0D0D5BBB0289";
          };
          aliases = {
            # For managing dotfiles, see: https://www.atlassian.com/git/tutorials/dotfiles
            config = "git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME";
          };
          extraConfig = {
            merge = {
              tool = "fugitive";
            };
            mergetool = {
              fugitive = {
                cmd = "${neovim}/bin/nvim -f -c \"Gvdiffsplit!\" \"$MERGED\"";
              };
            };
            pull = {
              rebase = true;
            };
            # Force SSH instead of HTTPS:
            # url."ssh://git@github.com/".insteadOf = "https://github.com/";
          };
        };
      };
      gtk = {
        enable = true;
        theme = {
          name = "Materia-dark";
          package = unstable.materia-theme;
        };
        iconTheme = {
          name = "Papirus-Dark";
          package = unstable.papirus-icon-theme;
        };
      };
    };
  };
}
