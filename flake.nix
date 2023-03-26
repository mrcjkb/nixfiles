{
  description = "Wrapper for creating a NixOS system configuration.";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    nvim-config = {
      url = "github:MrcJkb/nvim-config";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    xmonad-session.url = "github:MrcJkb/.xmonad";
    cursor-theme.url = "github:MrcJkb/volantes-cursors-material";
    feedback.url = "github:NorfairKing/feedback";
    gh2rockspec.url = "github:teto/gh2rockspec";
    nurl.url = "github:nix-community/nurl";
    # stylix.url = "github:mrcjkb/stylix";
    stylix.url = "github:danth/stylix?rev=d4759279ce0f60ed5991ce53abecd0fa80679aa4";
    base16schemes = {
      url = "github:tinted-theming/base16-schemes";
      flake = false;
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    gh2rockspec,
    nurl,
    stylix,
    base16schemes,
    pre-commit-hooks,
    ...
  } @ attrs: let
    supportedSystems = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    perSystem = nixpkgs.lib.genAttrs supportedSystems;
    pkgsFor = system: import nixpkgs {inherit system;};
    pre-commit-check-for = system:
      pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          alejandra.enable = true;
        };
      };
    shellFor = system: let
      pkgs = pkgsFor system;
      pre-commit-check = pre-commit-check-for system;
    in
      pkgs.mkShell {
        name = "nixfiles-devShell";
        inherit (pre-commit-check) shellHook;
        buildInputs = with pkgs; [
          alejandra
        ];
      };

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
            nvim-config.nixosModule
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
            xmonad-session.nixosModule
            stylix.nixosModules.stylix
            {
              environment.systemPackages = [
                xmonad-session.xmobar-package
                feedback.packages.${system}.default
                gh2rockspec.packages.${system}.default
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
  in {
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
    images = {
      baseIso = mkNixosSystem {extraModules = ["${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"];};
      rpi4 = rpi4.config.system.build.sdImage;
    };
    helpers = {
      inherit mkNixosSystem mkDesktopSystem;
    };
    modules = {
      inherit searx;
    };

    devShells = perSystem (system: {
      default = shellFor system;
    });

    checks = perSystem (system: {
      formatting = pre-commit-check-for system;
    });
  };
}
