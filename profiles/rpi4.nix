{
  inputs,
  lib,
  ...
}: {
  nixos.modules.rpi4 = {
    imports = [
      inputs.nixos-hardware.nixosModules.raspberry-pi-4
    ];

    fileSystems."/".device = lib.mkDefault "/dev/disk/by-label/NIXOS_SD";
    fileSystems."/".fsType = lib.mkDefault "ext4";
  };
}
