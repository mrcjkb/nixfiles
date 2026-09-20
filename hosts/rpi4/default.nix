{findModulesList, ...}: let
  hostModules = {
    imports = findModulesList ./.;
  };
in {
  nixos.configurations.rpi4 = {
    system = "aarch64-linux";
    user = "mrcjk";
    userEmail = "marc@jakobi.dev";
    profiles = [
      "base"
      "rpi4"
    ];
    extraModules = [hostModules];
  };
}
