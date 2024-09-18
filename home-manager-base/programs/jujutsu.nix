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
  };
}
