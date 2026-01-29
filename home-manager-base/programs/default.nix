{
  pkgs,
  userEmail,
  nu-scripts,
  ...
}: {
  atuin = import ./atuin.nix {inherit pkgs;};
  git = import ./git.nix {inherit userEmail pkgs;};
  jujutsu = import ./jujutsu.nix {inherit userEmail pkgs;};
  gh = import ./gh.nix;
  zoxide = import ./zoxide.nix pkgs.zoxide;
  nushell = import ./nushell.nix {
    inherit nu-scripts pkgs;
  };
  zsh = import ./zsh.nix {inherit pkgs;};
  direnv = import ./direnv.nix;
  tmux = import ./tmux.nix {inherit pkgs;};
  fzf = import ./fzf.nix;
  broot = import ./broot.nix;
  yazi = import ./yazi.nix;
}
