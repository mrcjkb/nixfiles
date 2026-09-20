{
  inputs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types;
in {
  options.nixos.modules = mkOption {
    type = types.lazyAttrsOf types.deferredModule;
    default = {};
  };

  options.nixos.configurations = mkOption {
    type = types.lazyAttrsOf (types.submodule {
      options = {
        system = mkOption {
          type = types.str;
          default = "x86_64-linux";
        };
        user = mkOption {
          type = types.str;
          default = "mrcjk";
        };
        userEmail = mkOption {
          type = types.str;
          default = "marc@jakobi.dev";
        };
        profiles = mkOption {
          type = types.listOf types.str;
          default = [];
        };
        extraModules = mkOption {
          type = types.listOf types.deferredModule;
          default = [];
        };
      };
    });
    default = {};
  };

  config.flake.nixosConfigurations = lib.mapAttrs (_: cfg:
    inputs.nixpkgs.lib.nixosSystem {
      system = cfg.system;
      specialArgs = {
        inherit inputs;
        defaultUser = cfg.user;
        inherit (cfg) userEmail;
        inherit (inputs) nu-scripts;
      };
      modules =
        [inputs.home-manager.nixosModules.default]
        ++ map (name: config.nixos.modules.${name}) cfg.profiles
        ++ cfg.extraModules;
    })
  config.nixos.configurations;
}
