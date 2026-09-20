{lib, ...}: {
  virtualisation = {
    libvirtd.enable = lib.mkDefault true;
  };
}
