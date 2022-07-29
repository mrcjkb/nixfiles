{
  description = "Wrapper for creating a NixOS system configuration.";

  inputs.nixpkgs-unstable.url = github:NixOS/nixpkgs/nixos-unstable;
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-22.05;
  inputs.nur.url = github:nix-community/NUR;
  inputs.home-manager.url = github:nix-community/home-manager/release-22.05;

  outputs = { self, nixpkgs, nixpkgs-unstable, nur, home-manager, ... }@attrs: 
  let
  overlay-unstable = final: prev: {
    unstable = nixpkgs-unstable.legacyPackages.${prev.system};
  };
  in {
    nixosSystem = { extraModules ? [], defaultUser ? "mrcjk", userEmail ? "mrcjkb89@outlook.com" }: nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs // {};
      modules = [
        # Overlays-module makes "pkgs.unstable" available in configuration.nix
        ({ config, pkgs, ... }: { nixpkgs.overlays = [ 
            overlay-unstable 
            nur.overlay
          ];
        })
        ./base.nix 
      ] ++ extraModules;
    };
  };
}
