{
  pkgs,
  userEmail,
  ...
}: {
  enable = true;
  userName = "Marc Jakobi";
  inherit userEmail;
  # signing = {
  #   key = "F31C0D0D5BBB0289";
  #   signByDefault = false;
  # };
  extraConfig = {
    merge.tool = "nvim";
    mergetool = {
      nvim = {
        cmd = "nvim -f -c \"DiffviewOpen\"";
      };
    };
    diff.tool = "nvim";
    difftool = {
      nvim = {
        cmd = "nvim -f -c \"DiffviewOpen $LOCAL..$REMOTE\"";
      };
    };
    pull = {
      rebase = true;
    };
    push = {
      autoSetupRemote = true;
    };
    # Force SSH instead of HTTPS:
    # url."ssh://git@github.com/".insteadOf = "https://github.com/";
  };
  ignores = [
    "Session.vim"
    ".hlint.yaml"
    "tags"
    ".direnv"
    ".pre-commit-config.yaml"
  ];
}
