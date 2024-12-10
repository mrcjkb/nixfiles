{
  description = "Wrapper for creating a NixOS system configuration.";

  nixConfig = {
    extra-substituters = [
      "https://mrcjkb.cachix.org"
      "https://arm.cachix.org"
    ];
    extra-trusted-public-keys = [
      "mrcjkb.cachix.org-1:KhpstvH5GfsuEFOSyGjSTjng8oDecEds7rbrI96tjA4="
      "arm.cachix.org-1:5BZ2kjoL1q6nWhlnrbAl+G7ThY7+HaBRD9PZzqZkbnM="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # home-manager.url = "/home/mrcjk/git/github/forks/home-manager/";
    nvim = {
      url = "github:mrcjkb/nvim";
    };
    xmonad-session.url = "github:mrcjkb/.xmonad";
    cursor-theme.url = "github:mrcjkb/volantes-cursors-material";
    feedback.url = "github:NorfairKing/feedback";
    # nurl.url = "github:nix-community/nurl";
    smos.url = "github:NorfairKing/smos/release";
    atuin.url = "github:atuinsh/atuin";
    # stylix.url = "github:mrcjkb/stylix";
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "home-manager";
    };
    nix-monitored = {
      url = "github:ners/nix-monitored";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    haskell-tags-nix = {
      url = "github:mrcjkb/haskell-tags-nix/mjkb/flake";
      # url = "github:shajra/haskell-tags-nix";
      # flake = false;
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nu-scripts = {
      url = "github:nushell/nu_scripts";
      flake = false;
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    starship-jj-patch = {
      url = "https://patch-diff.githubusercontent.com/raw/starship/starship/pull/5772.diff";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    git-hooks,
    flake-utils,
    ...
  }: let
    supportedSystems = builtins.attrNames nixpkgs.legacyPackages;

    searx = ./searx.nix;

    mkNixosSystem = {
      extraModules ? [],
      defaultUser ? "mrcjk",
      userEmail ? "marc@jakobi.dev",
      system ? "x86_64-linux",
      nixosSystem ? nixpkgs.lib.nixosSystem,
    }:
      nixosSystem {
        inherit system;
        specialArgs =
          inputs
          // {
            inherit
              defaultUser
              userEmail
              ;
            inherit (inputs) starship-jj-patch nu-scripts;
          };
        modules =
          [
            inputs.home-manager.nixosModules.default
            ({...}: {
              nixpkgs.overlays = with inputs; [
                nur.overlays.default
                atuin.overlays.default
                xmonad-session.overlays.default
              ];
            })
            ./base.nix
          ]
          ++ extraModules;
      };

    mkDesktopSystem = {
      extraModules ? [],
      defaultUser ? "mrcjk",
      userEmail ? "marc@jakobi.dev",
      system ? "x86_64-linux",
      nvim-pkg ? inputs.nvim.packages.${system}.nvim-dev,
    }:
      mkNixosSystem {
        inherit
          defaultUser
          userEmail
          system
          ;
        extraModules =
          extraModules
          ++ [
            inputs.nix-monitored.nixosModules.default
            ({
              config,
              pkgs,
              ...
            }: {
              nixpkgs.overlays = [
                inputs.cursor-theme.overlay
              ];
              home-manager.users.${defaultUser} = {
                imports = [
                  inputs.smos.homeManagerModules.${system}.default
                ];
              };
              nix.settings = let
                substituters = [
                  "https://smos.cachix.org"
                ];
              in {
                inherit substituters;
                trusted-substituters = substituters;
                trusted-public-keys = [
                  "smos.cachix.org-1:YOs/tLEliRoyhx7PnNw36cw2Zvbw5R0ASZaUlpUv+yM="
                ];
              };
            })
            ./desktop.nix
            inputs.xmonad-session.nixosModules.default
            inputs.stylix.nixosModules.stylix
            inputs.nixos-generators.nixosModules.all-formats
            {
              environment.systemPackages = [
                nvim-pkg
                inputs.feedback.packages.${system}.default
                inputs.haskell-tags-nix.packages.${system}.default
              ];
            }
          ];
      };

    mkInstaller = {
      extraModules ? [],
      userEmail ? "marc@jakobi.dev",
      system ? "x86_64-linux",
    }:
      mkDesktopSystem {
        inherit userEmail system;
        defaultUser = "nixos";
        nvim-pkg = inputs.nvim.packages.x86_64-linux.nvim;
        extraModules =
          extraModules
          ++ [
            ./configurations/installer/configuration.nix
          ];
      };

    rpi4 = let
      system = "aarch64-linux";
    in
      mkNixosSystem {
        inherit system;
        extraModules = [
          inputs.nixos-hardware.nixosModules.raspberry-pi-4
          ./configurations/rpi4/configuration.nix
        ];
      };
  in
    flake-utils.lib.eachSystem supportedSystems (system: let
      pkgs = import nixpkgs {inherit system;};
      pre-commit-check = git-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          alejandra.enable = true;
        };
      };
      shell = pkgs.mkShell {
        name = "nixfiles-devShell";
        inherit (pre-commit-check) shellHook;
        buildInputs = with pkgs; [
          alejandra
        ];
      };
    in {
      devShells = {
        default = shell;
      };

      checks = {
        inherit pre-commit-check;
      };
    })
    // {
      nixosConfigurations = {
        home-pc = mkDesktopSystem {
          extraModules = [
            ./configurations/home-pc/configuration.nix
            searx
          ];
        };
        p40yoga = mkDesktopSystem {
          extraModules = [
            ./configurations/p40yoga/configuration.nix
            searx
          ];
        };
        # nix build .#nixosSystems.installer.config.system.build.isoImage
        # USB_PATH=/dev/change/me
        # cp -vi result/iso/*.iso $USB_PATH
        installer = mkInstaller {};
      };

      images = {
        rpi4 =
          (self.nixosConfigurations.rpi4.extendModules {
            modules = ["${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"];
          })
          .config
          .system
          .build
          .sdImage;
      };

      helpers = {
        inherit mkNixosSystem mkDesktopSystem mkInstaller;
      };
    };
}
