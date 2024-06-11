{
  completion.enable = true;
  interactiveShellInit = ''
    # eval "$(zoxide init bash)"
    # if command -v fzf-share >/dev/null; then
    #   source "$(fzf-share)/key-bindings.bash"
    #   source "$(fzf-share)/completion.bash"
    # fi
  '';
  # promptInit = ''
  #   eval "$(starship init bash)"
  # '';
  shellAliases = {
    # mkdir = "mkdir -p";
    # vi = "nvim";
    # vim = "nvim";
    # nv = "neovide";
  };
}
