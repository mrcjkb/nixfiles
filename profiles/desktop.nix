{
  config,
  inputs,
  ...
}: {
  nixos.modules.desktop = {pkgs, ...}: {
    imports = [
      config.nixos.modules.base
      config.nixos.modules.battery
      config.nixos.modules.desktop-system
      config.nixos.modules.home-manager-desktop
      inputs.nix-monitored.nixosModules.default
      config.nixos.modules.xmonad
      inputs.stylix.nixosModules.stylix
      inputs.nixos-generators.nixosModules.all-formats
    ];

    environment.systemPackages = [
      inputs.feedback.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.serena.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
