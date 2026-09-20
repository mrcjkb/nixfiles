{findModulesList, ...}: {
  nixos.modules.battery = {
    imports = findModulesList ./.;
  };
}
