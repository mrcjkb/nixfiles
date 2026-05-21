{
  pkgs,
  userEmail,
  nu-scripts,
  ...
}: {
  atuin = import ./atuin.nix {inherit pkgs;};
  broot = import ./broot.nix;
  direnv = import ./direnv.nix;
  fzf = import ./fzf.nix;
  gh = import ./gh.nix;
  git = import ./git.nix {inherit userEmail pkgs;};
  jujutsu = import ./jujutsu.nix {inherit userEmail pkgs;};
  nushell = import ./nushell.nix {inherit nu-scripts pkgs;};
  starship = import ./starship.nix {inherit pkgs;};
  tmux = import ./tmux.nix {inherit pkgs;};
  yazi = import ./yazi.nix {inherit pkgs;};
  zoxide = import ./zoxide.nix pkgs.zoxide;
  zsh = import ./zsh.nix {inherit pkgs;};
}
