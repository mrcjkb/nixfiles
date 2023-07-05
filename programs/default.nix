{pkgs, ...}: {
  fish = import ./fish.nix;
  bash = import ./bash.nix;
  zsh.enable = true; # Configured with home-manager
  mtr.enable = true;
  gnupg = import ./gnupg.nix pkgs.unstable.gnupg;
  ssh = import ./ssh.nix;
  git.enable = true;
  htop.enable = true;
  tmux.enable = true;
  traceroute.enable = true;
}
