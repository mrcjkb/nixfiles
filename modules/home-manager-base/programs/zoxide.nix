{pkgs, ...}: {
  programs.zoxide = {
    package = pkgs.zoxide;
    enable = true;
  };
}
