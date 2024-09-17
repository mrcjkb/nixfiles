{
  userEmail,
  pkgs,
  ...
}: {
  enable = true;
  userName = "Marc Jakobi";
  lfs.enable = true;
  inherit userEmail;
  # signing = {
  #   key = "F31C0D0D5BBB0289";
  #   signByDefault = false;
  # };
  extraConfig = {
    core = {
      pager = "delta";
      untrackedcache = true;
      fsmonitor = true;
    };
    interactive.diffFilter = "delta --color-only";
    delta = {
      # use n and N to move between diff sections
      navigate = true;
      light = false;
      line-numbers = true;
    };
    merge = {
      tool = "nvim";
      # conflictstyle = "zdiff3";
    };
    mergetool = {
      nvim = {
        cmd = "nvim -f -c \"DiffviewOpen\"";
      };
    };
    diff = {
      tool = "difftastic";
      colorMoved = "default";
      algorithm = "histogram";
    };
    difftool = {
      prompt = false;
      # nvim = {
      #   cmd = "nvim -f -c \"DiffviewOpen $LOCAL..$REMOTE\"";
      # };
      difftastic = {
        cmd = ''difft --color always "$LOCAL" "$REMOTE"'';
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
      default = "current";
    };
    rebase = {
      autosquash = true;
    };
    init = {
      defaultBranch = "main";
    };
    commit.verbose = true;
    help.autocorrect = "prompt";
    # Force SSH instead of HTTPS:
    # url."ssh://git@github.com/".insteadOf = "https://github.com/";
    rerere.enabled = true; # reuse recorded resolution - auto fix previously fixed conflicts
    column.ui = "auto";
    branch.sort = "-committerdate";
    gpg.format = "ssh";
    credential = {
      helper = [
        # Must run 'git-credential-keepassxc configure' first, to connect with keepassxc
        "${pkgs.git-credential-keepassxc}/bin/git-credential-keepassxc --git-groups"
      ];
      # "https://github.com" = [
      #   "${pkgs.git-credential-oauth}/bin/git-credential-oauth"
      # ];
    };
  };
  ignores = [
    "Session.vim"
    ".hlint.yaml"
    "/tags"
    "!/*/tags"
    ".direnv"
    ".pre-commit-config.yaml"
  ];
}
