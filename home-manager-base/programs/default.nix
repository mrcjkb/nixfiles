{
  pkgs,
  userEmail,
  ...
}: {
  git = import ./git.nix {inherit pkgs userEmail;};
  gh = import ./gh.nix;
  zoxide = import ./zoxide.nix pkgs.zoxide;
  nushell = import ./nushell.nix pkgs.nushell;
  zsh = import ./zsh.nix;
  direnv = import ./direnv.nix;
  tmux = import ./tmux.nix {inherit pkgs;};
}
