{
  pkgs,
  lib,
  defaultUser,
  ...
}: {
  nix = let
    substituters = [
      "https://mrcjkb.cachix.org"
      "https://nix-community.cachix.org"
      "https://arm.cachix.org"
    ];
  in {
    package = lib.mkDefault pkgs.nix;
    extraOptions = ''
      allowed-uris = https://github.com
      auto-optimise-store = true
      keep-outputs = true
      keep-derivations = true
    '';
    # Binary Cache for Haskell.nix
    settings = {
      allowed-users = ["@wheel"];
      sandbox = lib.mkDefault true;
      auto-optimise-store = lib.mkDefault true;
      inherit substituters;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [defaultUser];
      trusted-substituters = substituters;
      trusted-public-keys = [
        "mrcjkb.cachix.org-1:KhpstvH5GfsuEFOSyGjSTjng8oDecEds7rbrI96tjA4="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "arm.cachix.org-1:5BZ2kjoL1q6nWhlnrbAl+G7ThY7+HaBRD9PZzqZkbnM="
      ];
      log-lines = 200;
    };
    gc = {
      # garbage collection
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "monthly";
      options = lib.mkDefault "--delete-older-than 30d";
    };
    # Set the nixPath for compatibility with `import <nixpkgs>` statements
    nixPath = ["nixpkgs=flake:nixpkgs"];
    buildMachines = [
      {
        systems = ["x86_64-darwin" "aarch64-darwin"];
        sshUser = "mrcjkb";
        sshKey = "/home/mrcjk/.ssh/community-builders";
        hostName = "darwin-build-box.nix-community.org";
        publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUZ6OEZYU1ZFZGY4RnZETWZib3hoQjVWalNlN3kyV2dTYTA5cTFMNHQwOTkgCg";
        maxJobs = 32;
        # protocol = "ssh-ng";
        supportedFeatures = [
          "apple-virt"
          "big-parallel"
        ];
        mandatoryFeatures = [];
      }
      {
        systems = [
          "i686-linux"
          "riscv64-linux"
          "x86_64-linux"
        ];
        sshUser = "mrcjkb";
        sshKey = "/home/mrcjk/.ssh/community-builders";
        hostName = "build-box.nix-community.org";
        publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUVsSVE1NHFBeTdEaDYzckJ1ZFlLZGJ6SkhycmJyck1YTFlsN1BrbWs4OEgK";
        # protocol = "ssh-ng";
        supportedFeatures = [
          "benchmark"
          "big-parallel"
          "kvm"
          "nixos-test"
        ];
        mandatoryFeatures = [];
      }
      {
        systems = ["aarch64-linux"];
        sshUser = "mrcjkb";
        sshKey = "/home/mrcjk/.ssh/community-builders";
        hostName = "aarch64-build-box.nix-community.org";
        publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUVsSVE1NHFBeTdEaDYzckJ1ZFlLZGJ6SkhycmJyck1YTFlsN1BrbWs4OEgK";
        # protocol = "ssh-ng";
        supportedFeatures = [
          "benchmark"
          "big-parallel"
          "kvm"
          "nixos-test"
        ];
        mandatoryFeatures = [];
      }
    ];
  };
}
