{
  self,
  inputs,
  ...
}: {
  flake.images = {
    rpi4 =
      (self.nixosConfigurations.rpi4.extendModules {
        modules = ["${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"];
      }).config.system.build.sdImage;
  };
}
