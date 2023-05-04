{
  enableCompletion = true;
  interactiveShellInit = ''
    eval "$(zoxide init bash)"
  '';
  # FIXME: Disabled for now because it seems buggy when in a nix shell
  # promptInit = ''
  #   eval "$(starship init bash)"
  # '';
  shellAliases = {
    mkdir = "mkdir -p";
    vi = "nvim";
    vim = "nvim";
    nv = "neovide";
  };
}
