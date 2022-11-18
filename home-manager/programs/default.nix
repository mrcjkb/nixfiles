{ pkgs, user, userEmail, ... }:
{
  git = import ./git.nix { inherit pkgs userEmail; };
  gh = import ./gh.nix;
  zoxide = import ./zoxide.nix pkgs.zoxide;
  alacritty = import ./alacritty.nix pkgs.alacritty;
  kitty = import ./kitty.nix pkgs.kitty;
}
