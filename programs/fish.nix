{
  enable = true;
  useBabelfish = true;
  shellInit = ''
    fish-nix-shell --info-right | source
    zoxide init fish | source
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
    # For managing dotfiles, see: https://www.atlassian.com/git/tutorials/dotfiles
    config = "git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME";
    vi = "nvim";
    vim = "nvim";
    nv = "neovide";
  };
}
