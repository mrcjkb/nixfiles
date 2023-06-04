{pkgs, ...}: {
  enable = true;
  package = pkgs.tmux;
  clock24 = true;
  disableConfirmationPrompt = true;
  keyMode = "vi";
  terminal = "screen-256color";
  tmuxinator.enable = true;
  plugins = with pkgs.tmuxPlugins; [
    sensible
    vim-tmux-navigator
    yank
  ];
  extraConfig = builtins.readFile ./tmux.conf;
}
