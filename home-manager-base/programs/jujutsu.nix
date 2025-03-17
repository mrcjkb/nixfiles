{
  userEmail,
  pkgs,
  ...
}: {
  enable = pkgs.lib.mkDefault true;
  ediff = true;
  settings = {
    user = {
      email = userEmail;
      name = "Marc Jakobi";
    };
    signing = {
      behavior = "own";
      backend = "gpg";
      key = "AA641BFC2D63E4A70ABBC89EA62702B226DB0A22";
    };
    git = {
      push-bookmark-prefix = "mj/push-";
      git.private-commits = "description(glob:'wip:*') | description(glob:'private:*')";
    };
    ui = {
      paginate = "never";
      editor = "nvim";
    };
    aliases = {
      # `jj l` shows commits on the working-copy commit's (anonymous) bookmark
      # compared to the `main` bookmark.
      # A decent revset for larger repositories.
      l = ["log" "-r" "(main..@):: | (main..@)-"];
      ll = ["log" "-r" "(master..@):: | (master..@)-"];
      lm = ["log" "-r" "mine()"];
      bto = ["bookmark" "track" "glob:*@origin"];
      # log my heads, showing only those with a description
      my-heads = ["log" "-r" "\heads(mine()) & description(regex:'.+')\""];
      # (this is more useful than 'jj bookmark list')
      my-bookmarks = ["log" "-r" "\heads(mine()) & bookmarks(regex:'.+')\""];
    };
    core = {
      fsmonitor = "watchman";
      watchman.register_snapshot_trigger = true;
    };
  };
}
