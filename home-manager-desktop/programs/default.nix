{pkgs, ...}: {
  alacritty = import ./alacritty.nix pkgs.alacritty;
  wezterm = import ./wezterm.nix pkgs.wezterm;
  git-credential-oauth.enable = true;
}
