# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  defaultUser,
  userEmail,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  services = {
    xserver = {
      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "altgr-intl";
      };
    };
  };

  # NOTE: The interface names have to be determined per device.
  # They can be extracted from the generated configuration.nix
  networking = {
    hostName = "nixos-home-pc";
    interfaces = {
      enp3s0.useDHCP = true;
    };
  };

  home-manager = {
    users."${defaultUser}" = {
      home.stateVersion = "21.11";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
