{
  lib,
  inputs,
  findModulesList,
  ...
}: {
  nixos.modules.overlays = {...}: {
    nixpkgs.overlays = lib.flatten (map (path: import path {inherit lib inputs;}) (findModulesList ../overlays));
  };
}
