{pkgs, ...}: {
  environment.systemPackages =
    (with pkgs.haskellPackages; [
      xmobar-app
      greenclip # Clipboard manager for use with rofi
    ])
    ++ (with pkgs; [
      dmenu # Expected by xmonad
      gxmessage # Used by xmonad to show help
      xkill # Kill X windows with the cursor
      warpd
      pango # Rendering library used by xmobar
    ]);
}
