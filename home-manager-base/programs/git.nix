{ pkgs, userEmail, ... }:
{
  enable = true;
  userName = "Marc Jakobi";
  inherit userEmail;
  # signing = {
  #   key = "F31C0D0D5BBB0289";
  #   signByDefault = false;
  # };
  extraConfig = {
    merge = {
      tool = "nvim";
    };
    mergetool = {
      nvim = {
        cmd = "${pkgs.neovim}/bin/nvim -f -c \"DiffViewOpen\"";
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
    "tags"
  ];
}
