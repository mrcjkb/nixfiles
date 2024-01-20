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
    core.pager = "delta";
    interactive.diffFilter = "delta --color-only";
    delta = {
      # use n and N to move between diff sections
      navigate = true;
      light = false;
      line-numbers = true;
    };
    merge.tool = "nvim";
    mergetool = {
      nvim = {
        cmd = "nvim -f -c \"DiffviewOpen\"";
      };
    };
    diff = {
      tool = "difftastic";
      colorMoved = "default";
    };
    difftool = {
      prompt = false;
      nvim = {
        cmd = "nvim -f -c \"DiffviewOpen $LOCAL..$REMOTE\"";
      };
      difftastic = {
        cmd = ''difft "$LOCAL" "$REMOTE"'';
      };
    };
    pager.difftool = true;
    alias = {
      dft = "difftool";
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
