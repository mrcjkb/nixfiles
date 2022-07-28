# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, vimUtils, ... }:

let
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/620ed197f3624dafa5f42e61d5c043f39b8df366.tar.gz";
    sha256 = "sha256-BoBvGT71yOfrNDTZQs7+FX0zb4yjMBETgIjtTsdJw+o=";
  };
  unstable = import <nixos-unstable> {/*  config = { allowUnfree = true; };  */}; # TODO: Fetch tarball
  defaultUser = "mrcjk"; # Default user account
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import ../base.nix { inherit pkgs unstable defaultUser; })
      (import "${home-manager}/nixos")
      (import ./networking.nix)
      (import ../xmonad-session { inherit pkgs; user = defaultUser; })
      (import ../searx.nix { package = unstable.searx; })
      (import ../home-manager { user = defaultUser; userEmail = "mrcjkb89@outlook.com"; neovim = unstable.neovim; inherit unstable; })
    ];


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

