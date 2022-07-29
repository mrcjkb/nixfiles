{
  description = "NixOS base configuration";

  inputs.unstable.url = github:nixpkgs/nixos-unstable;
  inputs.nixpkgs.url = github:nixpkgs/nixos-22.05;
  inputs.home-manager.url = github:nix-community/home-manager;
  inputs.nurpkgs.url = github:nix-community/NUR;

  outputs = { self, nixpkgs, ... }@attrs: {
    nixosConfigurations.nixos-tikodev = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = attrs;
        modules = [
          ./base.nix
          ./tiko-dev/configuration.nix
        ];
      };
    };
}
