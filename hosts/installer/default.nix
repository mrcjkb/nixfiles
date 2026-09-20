{findModulesList, ...}: let
  hostModules = {
    imports = findModulesList ./.;
  };
in {
  nixos.configurations.installer = {
    system = "x86_64-linux";
    user = "nixos";
    userEmail = "marc@jakobi.dev";
    profiles = ["desktop"];
    extraModules = [hostModules];
  };
}
