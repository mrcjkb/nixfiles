package: {
  inherit package;
  enable = true;
  installVimSyntax = true;
  enableBashIntegration = true;
  enableZshIntegration = true;
  clearDefaultKeybinds = true;
  settings = {
    command = "nu";
    cursor-style = "block_hollow";
    window-decoration = "none";
    window-show-tab-bar = "never";
    window-save-state = "always";
    keybind = [
      "ctrl+b>n=next_tab"
      "ctrl+b>p=previous_tab"
      "ctrl+b>t=new_tab"
      "ctrl+h=goto_split:left"
      "ctrl+j=goto_split:bottom"
      "ctrl+k=goto_split:top"
      "ctrl+l=goto_split:right"
      "ctrl+b>h=new_split:left"
      "ctrl+b>j=new_split:down"
      "ctrl+b>k=new_split:up"
      "ctrl+b>l=new_split:right"
      "ctrl+b>f=toggle_split_zoom"
      "ctrl++=increase_font_size:1"
      "ctrl+-=decrease_font_size:1"
      "ctrl+/=start_search"
      "ctrl+o>n=next_tab"
    ];
  };
}
