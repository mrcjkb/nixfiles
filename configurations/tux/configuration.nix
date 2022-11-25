# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  services = {
    xserver = {
      # Configure keymap in X11
      layout = "us";
      xkbVariant = "altgr-intl,";
      # Enable touchpad support (enabled default in most desktopManager).
      libinput.enable = true;
    };
  };

  networking = {
    hostName = "nixos-tux";
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      grub = {
        enableCryptodisk = true;
        device = "nodev";
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
    initrd.luks.devices = {
      root = {
        device = "/dev/disk/by-uuid/be31fac3-c477-4a0b-a1cf-0b9e838d7686";
        preLVM = true;
      };
    };
  };



  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system = {
    stateVersion = "22.05"; # Did you read the comment?
  };
}

