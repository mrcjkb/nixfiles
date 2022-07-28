# Edit this configuration file to define what should be installed on

# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, vimUtils, ... }:

let
  unstable = import <nixos-unstable> { } ;
  defaultUser = "mrcjk"; # Default user account
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import ../base.nix { inherit pkgs defaultUser; userEmail = "marc.jakobi@tiko.energy"; })
      (import ./networking.nix)
      (import ./openvpn { nixUser = defaultUser; openvpnUser = "marc.jakobi"; })
    ];


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {

    systemPackages = with pkgs; [
      #### NUR packages ###
      # (from mrcpkgs NUR package, managed by Marc Jakobi)
      # XXX Note: It may be necessary to update the nur tarball if a package is not found.
      nur.repos.mrcpkgs.yubikee-smartvpn # Automate SmartVPN login with YubiKey OAuth
      # tiko-related
      # lens # Kubernetes IDE
      kubernetes-helm
      vault
      sops
      git-crypt
      # Useful for development - experimentation
      prometheus
      prometheus-node-exporter
      grafana
    ];

    sessionVariables = rec {
      VAULT_ADDR = "https://vault.internal.tiko.ch";
    };

  };

  virtualisation.docker.enable = true;

  security = {
    sudo.extraRules = [
      { 
        users = [defaultUser];
        commands = [ 
          # Rules so that officeVPN service can be started and stopped without entering a password
          { command = "/run/current-system/sw/bin/systemctl stop openvpn-officeVPN"; options = [ "SETENV" "NOPASSWD" ]; }
          { command = "/run/current-system/sw/bin/systemctl start openvpn-officeVPN"; options = [ "SETENV" "NOPASSWD" ]; } 
        ];
      }
    ];
  };

  # Binary Cache for Haskell.nix
  # Note: To nixos-rebuild, pass `--opton substitue false` when not connected to Tiko VPN
  nix = {
    binaryCaches = [ 
      "https://cache.nixos.org"
      "https://iohk.cachix.org"
      "http://hydra.tiko.ch/"
      "https://hydra.iohk.io"
    ];
    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "hydra.tiko.ch:q8EX+cmvjysdFOPttZEl30cMv5tnB2dddkwrC61qdA4="
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}
