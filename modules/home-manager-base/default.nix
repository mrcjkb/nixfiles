{
  config,
  findModulesList,
  ...
}: let
  base = {
    imports = findModulesList ./.;
  };
in {
  homeManager.modules.base = base;

  nixos.modules.home-manager-base = {
    defaultUser,
    userEmail,
    nu-scripts,
    ...
  }: {
    home-manager = {
      extraSpecialArgs = {
        inherit userEmail nu-scripts;
        user = defaultUser;
      };
      users."${defaultUser}".imports = [
        base
        config.homeManager.modules.shell-aliases
      ];
    };
  };
}
