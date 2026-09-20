{findModulesList, ...}: {
  nixos.modules.xmonad-system = {
    imports = findModulesList ./session;
  };
}
