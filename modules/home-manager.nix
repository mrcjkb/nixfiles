{
  inputs,
  lib,
  config,
  withSystem,
  ...
}: let
  inherit (lib) mkOption types;
in {
  options.homeManager = {
    modules = mkOption {
      type = types.lazyAttrsOf types.deferredModule;
      default = {};
    };

    configurations = mkOption {
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
          modules = mkOption {
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
  };

  config.flake.homeConfigurations = lib.mapAttrs (_: cfg:
    withSystem cfg.system ({pkgs, ...}:
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit (cfg) user userEmail;
          inherit (inputs) nu-scripts;
        };
        modules =
          map (name: config.homeManager.modules.${name}) cfg.modules
          ++ cfg.extraModules;
      }))
  config.homeManager.configurations;
}
