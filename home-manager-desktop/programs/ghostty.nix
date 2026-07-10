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
      "ctrl+shift+h=resize_split:left,10"
      "ctrl+shift+j=resize_split:down,10"
      "ctrl+shift+k=resize_split:up,10"
      "ctrl+shift+l=resize_split:right,10"
      "ctrl+b>h=new_split:left"
      "ctrl+b>j=new_split:down"
      "ctrl+b>k=new_split:up"
      "ctrl+b>l=new_split:right"
      "ctrl+b>f=toggle_split_zoom"
      "ctrl++=increase_font_size:1"
      "ctrl+==increase_font_size:1"
      "ctrl+-=decrease_font_size:1"
      "ctrl+/=start_search"
      "ctrl+shift+v=paste_from_clipboard"
      "paste=paste_from_clipboard"
      "ctrl+shift+c=copy_to_clipboard"
      "copy=copy_to_clipboard"
      "ctrl+shift+a=select_all"
      "ctrl+b>p=toggle_command_palette"
      "alt+digit_1=goto_tab:1"
      "alt+digit_2=goto_tab:2"
      "alt+digit_3=goto_tab:3"
      "alt+digit_4=goto_tab:4"
      "alt+digit_5=goto_tab:5"
      "alt+digit_6=goto_tab:6"
      "alt+digit_7=goto_tab:7"
      "alt+digit_8=goto_tab:8"
      "shift+arrow_down=adjust_selection:down"
      "shift+arrow_left=adjust_selection:left"
      "shift+arrow_right=adjust_selection:right"
      "shift+arrow_up=adjust_selection:up"
    ];
  };
}
