{
  enableCompletion = true;
  interactiveShellInit = ''
    eval "$(zoxide init bash)"
  '';
  promptInit = ''
    eval "$(starship init bash)"
  '';
  shellAliases = {
    mkdir = "mkdir -p";
    vi = "nvim";
    vim = "nvim";
    nv = "neovide";
  };
}
