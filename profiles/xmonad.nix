{config, ...}: {
  nixos.modules.xmonad = {
    imports = [config.nixos.modules.xmonad-system];
  };
}
