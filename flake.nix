{
  description = "Wrapper for creating a NixOS system configuration.";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    nvim-config.url = "github:MrcJkb/nvim-config";
    xmonad-session.url = "github:MrcJkb/.xmonad";
    cursor-theme.url = "github:MrcJkb/volantes-cursors-material";
    feedback.url = "github:NorfairKing/feedback";
    gh2rockspec.url = "github:teto/gh2rockspec";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nur, home-manager,
              nvim-config, xmonad-session, cursor-theme,
              feedback, gh2rockspec,
              ... }@attrs:
  let
    overlay-unstable = final: prev: {
      unstable = nixpkgs-unstable.legacyPackages.${prev.system};
    };
    direnv-overlay = final: prev: {
      nix-direnv = prev.nix-direnv.override { enableFlakes = true; };
    };
    searx = ./searx.nix;
    mkNixosSystem = {
      extraModules ? [],
      defaultUser ? "mrcjk",
      userEmail ? "mrcjkb89@outlook.com",
      system ? "x86_64-linux",
      }: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = attrs // { inherit defaultUser userEmail; };
      modules = [
        # Overlays-module makes "pkgs.unstable" available in configuration.nix
        ({ config, pkgs, ... }: { nixpkgs.overlays = [
            overlay-unstable
            nur.overlay
            direnv-overlay
          ];
        })
        ./base.nix
        home-manager.nixosModule
        nvim-config.nixosModule
      ] ++ extraModules;
    };
    mkDesktopSystem = { extraModules ? [], defaultUser ? "mrcjk", userEmail ? "mrcjkb89@outlook.com", system ? "x86_64-linux" }: mkNixosSystem {
      extraModules = extraModules ++ [
        ({ config, pkgs, ... }: { nixpkgs.overlays = [
            cursor-theme.overlays.default
          ];
        })
        ./desktop.nix
        xmonad-session.nixosModule
        { environment.systemPackages = [
          xmonad-session.xmobar-package
          feedback.packages.${system}.default
          gh2rockspec.packages.${system}.default
        ]; }
      ];
    };
    rpi4 = let
      system = "aarch64-linux";
    in mkNixosSystem {
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
      baseIso = mkNixosSystem { extraModules = ["${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"];};
      rpi4 = rpi4.config.system.build.sdImage;
    };
    helpers = {
      inherit mkNixosSystem mkDesktopSystem;
    };
    modules = {
      inherit searx;
    };
  };
}
