{
  pkgs,
  userEmail,
  ...
}: {
  git = import ./git.nix {inherit pkgs userEmail;};
  gh = import ./gh.nix;
  zoxide = import ./zoxide.nix pkgs.zoxide;
  nushell = import ./nushell.nix pkgs.nushell;
  zsh = import ./zsh.nix {inherit pkgs;};
  direnv = import ./direnv.nix;
  tmux = import ./tmux.nix {inherit pkgs;};
  fzf = import ./fzf.nix;
  broot = import ./broot.nix;
}
