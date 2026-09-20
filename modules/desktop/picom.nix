{...}: {
  services.picom = {
    enable = true;
    activeOpacity = 1.0;
    inactiveOpacity = 1.0;
    backend = "glx";
    fade = false;
    shadow = false;
  };
}
