{lib, ...}: {
  services.xserver = {
    displayManager.startx.enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = lib.readFile ../../xmonad/xmonadrc/xmonad.hs;
      extraPackages = hpkgs:
        with hpkgs; [
          xmonadrc
        ];
    };
  };
}
