# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{defaultUser, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  services = {
    xserver = {
      # Configure keymap in X11
      xkb = {
        layout = "us,de";
        variant = "altgr-intl,";
        options = "grp:alt_shift_toggle";
      };
    };
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
    # Prevent overheating on intel CPUs
    thermald.enable = true;
    # save power on laptops
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVENOR_ON_AC = "performance";
        CPU_SCALING_GOVENOR_ON_BAT = "powersave";
        CPU_ENERGY_POLICY_ON_AC = "performance";
        CPU_ENERGY_POLICY_ON_BAT = "power";
        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;
      };
    };
  };

  networking = {
    hostName = "nixos-p40";
  };

  boot.loader = {
    grub.enable = false;
    systemd-boot = {
      enable = true;
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
  };

  home-manager = {
    users."${defaultUser}".home.stateVersion = "22.05";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
