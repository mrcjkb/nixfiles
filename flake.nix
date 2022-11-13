{
  description = "Wrapper for creating a NixOS system configuration.";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    nvim-config.url = "github:MrcJkb/nvim-config";
    xmonad-session.url = "github:MrcJkb/.xmonad";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nur, home-manager,
              nvim-config, xmonad-session, ... }@attrs:
  let
    overlay-unstable = final: prev: {
      unstable = nixpkgs-unstable.legacyPackages.${prev.system};
    };
    mkNixosSystem = { extraModules ? [], defaultUser ? "mrcjk", userEmail ? "mrcjkb89@outlook.com" }: nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs // { inherit defaultUser userEmail; };
      modules = [
        # Overlays-module makes "pkgs.unstable" available in configuration.nix
        ({ config, pkgs, ... }: { nixpkgs.overlays = [
            overlay-unstable
            nur.overlay
          ];
        })
        ./base.nix
        home-manager.nixosModule
        nvim-config.nixosModule
        xmonad-session.nixosModule
      ] ++ extraModules;
    };
  in {
    nixosConfigurations = {
      home-pc = mkNixosSystem {
        extraModules = [
          ./configurations/home-pc/configuration.nix
        ];
      };
      p40yoga = mkNixosSystem {
        extraModules = [
          ./configurations/p40yoga/configuration.nix
        ];
      };
    };
    baseIso = mkNixosSystem { extraModules = ["${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"];};
    inherit mkNixosSystem;
  };
}
