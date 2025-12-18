{config, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./steam.nix
  ];

  networking = {
    hostName = "nixos-framework";
    # Disabled, because networking.useDHCP is set to true in hardware-configuration.nix
    # interfaces = {
    #   wlp1s0.useDHCP = lib.mkDefault true; # expansion bay module (no gpu)
    #   wlp4s0.useDHCP = lib.mkDefault true; # amdgpu module
    # };
  };

  boot = {
    initrd.luks.devices = {
      crypted = {
        device = "/dev/disk/by-uuid/bd2abb25-4ceb-4f75-8868-71581bfbb52d";
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
