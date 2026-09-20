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
      inputs.xmonad-session.nixosModules.default
      inputs.stylix.nixosModules.stylix
      inputs.nixos-generators.nixosModules.all-formats
    ];

    environment.systemPackages = [
      inputs.nvim.packages.${pkgs.stdenv.hostPlatform.system}.nvim
      inputs.feedback.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.serena.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
