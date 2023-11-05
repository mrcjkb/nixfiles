{
  pkgs,
  userEmail,
  nu-scripts,
  ...
}: {
  atuin = import ./atuin.nix;
  git = import ./git.nix {inherit pkgs userEmail;};
  gh = import ./gh.nix;
  zoxide = import ./zoxide.nix pkgs.zoxide;
  nushell = import ./nushell.nix {
    package = pkgs.nushell;
    inherit nu-scripts;
  };
  zsh = import ./zsh.nix {inherit pkgs;};
  direnv = import ./direnv.nix;
  tmux = import ./tmux.nix {inherit pkgs;};
  fzf = import ./fzf.nix;
  broot = import ./broot.nix;
}
