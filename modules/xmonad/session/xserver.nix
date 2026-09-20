{lib, ...}: {
  services.xserver = {
    displayManager.startx.enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = lib.readFile ../xmonadrc/xmonad.hs;
      extraPackages = hpkgs:
        with hpkgs; [
          xmonadrc
        ];
    };
  };
}
