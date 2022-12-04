package: {
  inherit package;
  enable = true;
  extraConfig = builtins.readFile ./wezterm.lua;
  colorSchemes = {
    mrcjk = rec {
      ansi = [
         "#212121"
         "#FF5370"
         "#ABCF76"
         "#E6B455"
         "#6E98EB"
         "#B480D6"
         "#71C6E7"
         "#FFFFFF"
      ];
      brights = [
         "#424242"
         "#F07178"
         "#C3E88D"
         "#f0c674"
         "#B0C9FF"
         "#C792EA"
         "#89DDFF"
         "#FFFFFF"
      ];
      foreground = "#DDDDDD";
      background = "#212121";
      cursor_bg = foreground;
      cursor_border ="#c5c8c6";
      cursor_fg = background;
      selection_bg = "#B480D6";
      selection_fg = background;
    };
  };
}
