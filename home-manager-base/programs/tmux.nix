{pkgs, ...}: {
  enable = true;
  package = pkgs.tmux;
  clock24 = true;
  disableConfirmationPrompt = true;
  keyMode = "vi";
  terminal = "screen-256color";
  tmuxinator.enable = true;
  newSession = true; # Automatically spawn a session if trying to attach and none are running.
  plugins = with pkgs.tmuxPlugins; [
    sensible
    vim-tmux-navigator
    yank
  ];
  extraConfig = builtins.readFile ./tmux.conf;
}
