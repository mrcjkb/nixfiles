{
  enable = true;
  useBabelfish = true;
  shellInit = ''
    fish_vi_key_bindings
    fish_vi_cursor
    fish-nix-shell --info-right | source
    zoxide init fish | source
    set fish_greeting
  '';
  promptInit = ''
    starship init fish | source
  '';
  shellAliases = import ./shellAliases.nix;
}
