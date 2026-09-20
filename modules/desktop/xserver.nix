{lib, ...}: {
  services = {
    xserver = {
      xkb = {
        layout = lib.mkDefault "us";
        variant = lib.mkDefault "altgr-intl";
        options = lib.mkDefault "terminate:ctrl_alt_bksp,caps:escape";
      };
    };
    # Enable touchpad support
    libinput.enable = lib.mkDefault true;
  };
}
