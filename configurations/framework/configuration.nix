{
  config,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "nixos-framework";
    interfaces = {
      wlp4s0.useDHCP = lib.mkDefault true;
    };
  };

  services.xserver.videoDrivers = [
    "amdgpu"
  ];

  boot = {
    initrd.luks.devices = {
      crypted = {
        device = "/dev/disk/by-uuid/7e8799c4-fdec-4351-9ec6-9c6e933f0c27";
        preLVM = true;
      };
    };
    tmp = {
      useTmpfs = true;
      tmpfsSize = "14G";
    };
    loader = {
      grub = {
        enable = true;
        enableCryptodisk = true;
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
  };

  home-manager = {
    users.mrcjk = {
      home.stateVersion = config.system.stateVersion;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system = {
    stateVersion = "25.05"; # Did you read the comment?
  };
}
