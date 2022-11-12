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
  shellAliases = {
    cd = "z";
    bd = "prevd";
    nd = "nextd";
    exa = "exa --icons --git";
    ls = "exa --icons --git";
    la = "exa --icons --git -a";
    ll = "ls --icons --git -l";
    lt = "ls --icons --tree";
    ltg = "lt --git";
    lta = "lt -a";
    ltl = "lt -l";
    lla = "ls --icons --git -al";
    grep = "rg";
    cat = "bat --style=plain";
    mkdir = "mkdir -p";
    vi = "nvim";
    vim = "nvim";
    nv = "neovide";
  };
}
