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
      sign-all = true;
      key = "E35672602EEA430245D61B53071AC75AA313BFCA";
    };
    git.push-bookmark-prefix = "mj/push-";
    ui.paginate = "never";
    aliases = {
      # `jj l` shows commits on the working-copy commit's (anonymous) bookmark
      # compared to the `main` bookmark
      l = ["log" "-r" "(main..@):: | (main..@)-"];
    };
  };
}
