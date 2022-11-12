{ pkgs, user, userEmail, ... }:
{
  git = import ./git.nix { inherit pkgs userEmail; };
  zoxide = import ./zoxide.nix;
}
