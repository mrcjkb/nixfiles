{ pkgs, user, userEmail, ... }:
{
  alacritty = import ./alacritty.nix pkgs.alacritty;
  wezterm = import ./wezterm.nix pkgs.wezterm;
}
