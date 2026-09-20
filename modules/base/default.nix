{findModulesList, ...}: {
  nixos.modules.base-system = {
    imports = findModulesList ./.;
  };
}
