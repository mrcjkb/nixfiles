{
  config,
  findModulesList,
  ...
}: let
  hostModules = {
    imports = findModulesList ./.;
  };
in {
  nixos.configurations.p40yoga = {
    system = "x86_64-linux";
    user = "mrcjk";
    userEmail = "marc@jakobi.dev";
    profiles = ["desktop"];
    extraModules = [
      config.nixos.modules.searx
      hostModules
    ];
  };
}
