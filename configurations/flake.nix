{
  description = "NixOS configuration";

  inputs.base = {
    url = github:MrcJkb/nixfiles;
  };

  outputs = { self, base, ... }@attrs: {
    nixosConfigurations = {
      nixos-home-pc = base.nixosSystem {
        extraModules = [
          ./home-pc/configuration.nix
        ];
      };
    };
  };
}
