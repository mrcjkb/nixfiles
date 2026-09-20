{lib, ...}: {
  # For building Raspberry Pi images
  boot = {
    binfmt.emulatedSystems = ["aarch64-linux"];
    plymouth.enable = lib.mkDefault false; # boot animation
  };
}
