{findModulesList, ...}: {
  nixos.modules.searx = {
    imports = findModulesList ./.;
  };
}
