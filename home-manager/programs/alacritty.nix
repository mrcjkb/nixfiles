package: {
  inherit package;
  enable = true;
  settings = {
    colors = {
      primary = {
        background = "#212121";
        foreground = "#39EA49";
      };
      # Normal colors
      normal = {
        black = "#000000";
        red = "#F25056";
        green = "#39EA49";
        yellow = "#FAC536";
        blue = "#FAC536";
        magenta = "#D12EEB";
        cyan = "#D12EEB";
        white = "#C7C7C7";
      };
      # Bright colors
      bright = {
        black = "#686868";
        red = "#F07178";
        green = "#C2D94C";
        yellow = "#FFB454";
        blue = "#59C2FF";
        magenta = "#FFEE99";
        cyan = "#95E6CB";
        white = "#FFFFFF";
     };
    };
    font = {
      # The normal (roman) font face to use.
      normal = {
        family = "JetBrains Mono Nerd Font Mono Medium";
        # Style can be specified to pick a specific face.
        style = "Regular";
      };
      # The bold font face
      bold = {
        family = "JetBrains Mono Nerd Font Mono Medium";
        # Style can be specified to pick a specific face.
        style = "Bold";
      };
      # The italic font face
      italic = {
        family = "JetBrains Mono Nerd Font Mono Medium";
        # Style can be specified to pick a specific face.
        style = "Italic";
      };
      size = 16.0;
    };
    env = {
      WINIT_X11_SCALE_FACTOR = "1.0";
    };
    key_bindings = [
      { key = "Equals"; mods = "Control"; action = "IncreaseFontSize"; }
      { key = "Minus"; mods = "Control"; action = "DecreaseFontSize"; }
    ];
  };
}
