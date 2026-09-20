{defaultUser, ...}: {
  home-manager.users."${defaultUser}" = {
    xdg.configFile."rofi" = {
      # TODO: use home-manager module
      source = ../configs/rofi/.;
      recursive = true;
    };
    programs.rofi.enable = true;
  };
}
