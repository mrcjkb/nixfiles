{lib, ...}: {
  services.displayManager.defaultSession = lib.mkDefault "none+xmonad";
}
