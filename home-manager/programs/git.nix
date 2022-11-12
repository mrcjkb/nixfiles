{ pkgs, userEmail, ... }:
{
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
}
