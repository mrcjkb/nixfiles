{
  pkgs,
  lib,
  ...
}: let
  jetbrains-mono-nerdfont = pkgs.nerd-fonts.jetbrains-mono;
in {
  stylix = {
    enable = lib.mkDefault true;
    image = pkgs.fetchurl {
      url = "https://user-images.githubusercontent.com/12857160/213937865-c910a41c-2092-48d1-83cc-e1776da0ec14.png";
      sha256 = "pnvx65H/OewNAodCiM3YB41+JzS+uYrS6o9xO4fJm+0=";
    };
    polarity = "dark";
    base16Scheme = ../../data/catppuccin-mocha.yaml;
    fonts = {
      serif = {
        package = jetbrains-mono-nerdfont;
        name = "JetBrains Mono Nerd Font Mono";
      };

      sansSerif = {
        package = jetbrains-mono-nerdfont;
        name = "JetBrains Mono Nerd Font Mono";
      };

      monospace = {
        package = jetbrains-mono-nerdfont;
        name = "JetBrains Mono Nerd Font Mono";
      };

      emoji = {
        package = jetbrains-mono-nerdfont;
        name = "JetBrains Mono Nerd Font Mono";
      };

      sizes = {
        terminal = 16;
        applications = 14;
        desktop = 12;
      };
    };
    cursor = {
      name = "Volantes Catppuccin (Mocha Dark)";
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 24;
    };
    targets = {
      # NOTE: If a target does not exist, it belongs in home-manager-desktop/default.nix
      grub = {
        enable = true;
        # useImage = true;
      };
    };
  };
}
