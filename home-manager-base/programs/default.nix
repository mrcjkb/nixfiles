{
  pkgs,
  user,
  userEmail,
  ...
}: {
  git = import ./git.nix {inherit pkgs userEmail;};
  gh = import ./gh.nix;
  zoxide = import ./zoxide.nix pkgs.zoxide;
  nushell = import ./nushell.nix pkgs.nushell;
  direnv = import ./direnv.nix;
}
