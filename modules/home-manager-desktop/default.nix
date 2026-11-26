{findModulesList, ...}: let
  desktop = {
    imports = findModulesList ./.;
  };
in {
  homeManager.modules.desktop = desktop;

  nixos.modules.home-manager-desktop = {defaultUser, ...}: {
    home-manager = {
      sharedModules = [
        {
          stylix.targets = {
            mako.enable = false;
            kde.enable = false;
          };
        }
      ];
      users."${defaultUser}".imports = [desktop];
    };
  };
}
