{pkgs, ...}: {
  firejail = import ./firejail.nix pkgs;
  slock.enable = true;
}
