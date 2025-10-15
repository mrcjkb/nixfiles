package: {
  inherit package;
  enable = true;
  settings = {
    terminal.shell = {
      program = "tmux";
      args = [
        "new-session"
        "-A"
        "-D"
        "-s"
        "main"
      ];
    };
    font = {
      # The normal (roman) font face to use.
      normal = {
        family = "JetBrains Mono Nerd Font Mono";
        # Style can be specified to pick a specific face.
        style = "Regular";
      };
      # The bold font face
      bold = {
        family = "JetBrains Mono Nerd Font Mono";
        # Style can be specified to pick a specific face.
        style = "Bold";
      };
      # The italic font face
      italic = {
        family = "JetBrains Mono Nerd Font Mono";
        # Style can be specified to pick a specific face.
        style = "Italic";
      };
      # size = 16.0;
    };
    env = {
      WINIT_X11_SCALE_FACTOR = "1.0";
      term = "xterm-256color";
    };
    keyboard.bindings = [
      {
        key = "Equals";
        mods = "Control";
        action = "IncreaseFontSize";
      }
      {
        key = "Minus";
        mods = "Control";
        action = "DecreaseFontSize";
      }
    ];
  };
}
