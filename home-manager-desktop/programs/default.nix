{pkgs, ...}: {
  alacritty = import ./alacritty.nix pkgs.alacritty;
  wezterm = import ./wezterm.nix pkgs.wezterm;

  # a buggy nixpkgs module causing infinite recursion in evaluation
  swaylock.enable = pkgs.lib.mkForce false;
}
