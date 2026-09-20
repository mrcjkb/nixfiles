# Base module to be added to desktop systems
{findModulesList, ...}: {
  nixos.modules.desktop-system = {
    imports = findModulesList ./.;
  };
}
