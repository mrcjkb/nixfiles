{
  description = "Wrapper for creating a NixOS system configuration.";

  nixConfig = {
    extra-substituters = "https://mrcjkb.cachix.org";
    extra-trusted-public-keys = "mrcjkb.cachix.org-1:KhpstvH5GfsuEFOSyGjSTjng8oDecEds7rbrI96tjA4=";
  };

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    nvim-config = {
      url = "github:mrcjkb/nvim-config";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    xmonad-session.url = "github:mrcjkb/.xmonad";
    cursor-theme.url = "github:mrcjkb/volantes-cursors-material";
    feedback.url = "github:NorfairKing/feedback";
    nurl.url = "github:nix-community/nurl";
    # stylix.url = "github:mrcjkb/stylix";
    stylix.url = "github:danth/stylix/release-22.11";
    base16schemes = {
      url = "github:tinted-theming/base16-schemes";
      flake = false;
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    nur,
    home-manager,
    nvim-config,
    xmonad-session,
    cursor-theme,
    feedback,
    nurl,
    stylix,
    base16schemes,
    pre-commit-hooks,
    flake-utils,
    ...
  } @ attrs: let
    supportedSystems = [
      "aarch64-linux"
      "x86_64-linux"
    ];

    overlay-unstable = final: prev: {
      unstable = nixpkgs-unstable.legacyPackages.${prev.system};
    };

    direnv-overlay = final: prev: {
      nix-direnv = prev.nix-direnv.override {enableFlakes = true;};
    };

    searx = ./searx.nix;

    mkNixosSystem = {
      extraModules ? [],
      defaultUser ? "mrcjk",
      userEmail ? "mrcjkb89@outlook.com",
      system ? "x86_64-linux",
    }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = attrs // {inherit defaultUser userEmail base16schemes;};
        modules =
          [
            # Overlays-module makes "pkgs.unstable" available in configuration.nix
            ({...}: {
              nixpkgs.overlays = [
                overlay-unstable
                nur.overlay
                direnv-overlay
              ];
            })
            ./base.nix
            home-manager.nixosModules.home-manager
            nvim-config.nixosModules.default
          ]
          ++ extraModules;
      };

      mkDesktopSystem = {
        extraModules ? [],
        defaultUser ? "mrcjk",
        userEmail ? "mrcjkb89@outlook.com",
        system ? "x86_64-linux",
      }:
        mkNixosSystem {
          extraModules =
            extraModules
            ++ [
              ({
                config,
                pkgs,
                ...
              }: {
                nixpkgs.overlays = [
                  cursor-theme.overlay
                ];
              })
              ./desktop.nix
              xmonad-session.nixosModules.default
              stylix.nixosModules.stylix
              {
                environment.systemPackages = [
                  feedback.packages.${system}.default
                  nurl.packages.${system}.default
                ];
              }
            ];
        };

      rpi4 = let
        system = "aarch64-linux";
      in
        mkNixosSystem {
          inherit system;
          extraModules = [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
            {
              nixpkgs.config.allowUnsupportedSystem = true;
              nixpkgs.crossSystem.system = system;
            }
            ./configurations/rpi4/configuration.nix
          ];
        };
  in
    flake-utils.lib.eachSystem supportedSystems (system: let
      pkgs = import nixpkgs {inherit system;};
      pre-commit-check = pre-commit-hooks.lib.${system}.run {
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

      # images = {
      #   baseIso = mkNixosSystem {extraModules = ["${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"];};
      #   rpi4 = rpi4.config.system.build.sdImage;
      # };

      devShells = {
        default = shell;
      };

      checks = {
        inherit pre-commit-check;
      };
    }) // {
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
        inherit rpi4;
      };

      helpers = {
        inherit mkNixosSystem mkDesktopSystem;
      };

    };
}
