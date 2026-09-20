{findModulesList, ...}: {
  nixos.modules.xmonad-session = {
    imports = findModulesList ./.;
  };
}
