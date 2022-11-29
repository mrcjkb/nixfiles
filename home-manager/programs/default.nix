{ pkgs, user, userEmail, ... }:
{
  git = import ./git.nix { inherit pkgs userEmail; };
  gh = import ./gh.nix;
  zoxide = import ./zoxide.nix pkgs.zoxide;
  alacritty = import ./alacritty.nix pkgs.alacritty;
  # wezterm = import ./wezterm.nix pkgs.wezterm;
  nushell = import ./nushell.nix pkgs.nushell;
  direnv = import ./direnv.nix;
}
