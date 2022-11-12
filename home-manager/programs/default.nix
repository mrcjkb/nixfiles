{ pkgs, user, userEmail, ... }:
{
  git = import ./git.nix { inherit pkgs userEmail; };
  zoxide = import ./zoxide.nix pkgs.zoxide;
  alacritty = import ./alacritty.nix pkgs.alacritty;
}
