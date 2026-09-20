{findModulesList, ...}: let
  hostModules = {
    imports = findModulesList ./.;
  };
in {
  nixos.configurations.framework = {
    system = "x86_64-linux";
    user = "mrcjk";
    userEmail = "marc@jakobi.dev";
    profiles = [
      "desktop"
      "framework"
    ];
    extraModules = [hostModules];
  };
}
