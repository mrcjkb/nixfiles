{pkgs, ...}: {
  firejail = import ./firejail.nix pkgs.unstable;
}
