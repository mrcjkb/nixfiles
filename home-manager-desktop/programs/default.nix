{pkgs, ...}: {
  alacritty = import ./alacritty.nix pkgs.alacritty;
  iamb = import ./iamb.nix;
  ghostty = import ./ghostty.nix pkgs.ghostty;

  # a buggy nixpkgs module causing infinite recursion in evaluation
  swaylock.enable = pkgs.lib.mkForce false;
}
