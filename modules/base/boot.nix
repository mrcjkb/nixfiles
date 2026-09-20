{lib, ...}: {
  boot.loader.timeout = lib.mkDefault 2;

  # Boot loader
  boot = {
    loader = {
      grub = {
        enable = lib.mkDefault true;
        efiSupport = lib.mkDefault true;
        device = "nodev";
        configurationLimit = 4;
      };
    };
    tmp = {
      cleanOnBoot = lib.mkDefault true;
    };
    supportedFilesystems = ["ntfs"];
    kernel.sysctl."kernel.sysrq" = 502;
  };

  fileSystems = {
    "/".options = ["noatime" "nodiratime"];
  };
}
