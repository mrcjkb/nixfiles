{pkgs, ...}: {
  zsh = import ./zsh.nix;
  fish = import ./fish.nix;
  bash = import ./bash.nix;
  mtr.enable = true;
  gnupg = import ./gnupg.nix pkgs.unstable.gnupg;
  ssh = import ./ssh.nix;
  git.enable = true;
  htop.enable = true;
  tmux.enable = true;
  traceroute.enable = true;
}
