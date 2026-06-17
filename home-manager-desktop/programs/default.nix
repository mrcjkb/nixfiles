{pkgs, ...}: {
  alacritty = import ./alacritty.nix pkgs.alacritty;
  iamb = import ./iamb.nix;
  wezterm = import ./wezterm.nix pkgs.wezterm;

  # a buggy nixpkgs module causing infinite recursion in evaluation
  swaylock.enable = pkgs.lib.mkForce false;
}
