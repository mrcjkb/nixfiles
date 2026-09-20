{
  description = "Wrapper for creating a NixOS system configuration.";

  nixConfig = {
    extra-substituters = [
      "https://mrcjkb.cachix.org"
      "https://arm.cachix.org"
    ];
    extra-trusted-public-keys = [
      "mrcjkb.cachix.org-1:KhpstvH5GfsuEFOSyGjSTjng8oDecEds7rbrI96tjA4="
      "arm.cachix.org-1:5BZ2kjoL1q6nWhlnrbAl+G7ThY7+HaBRD9PZzqZkbnM="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim = {
      url = "github:mrcjkb/nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser.url = "github:mrcjkb/zen-browser-flake";
    feedback = {
      url = "github:NorfairKing/feedback";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    atuin = {
      url = "github:atuinsh/atuin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tmux-sessionizer = {
      url = "github:jrmoulton/tmux-sessionizer";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    serena = {
      url = "github:oraios/serena";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-monitored = {
      url = "github:ners/nix-monitored";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nu-scripts = {
      url = "github:nushell/nu_scripts";
      flake = false;
    };
    bash-env-nushell = {
      url = "github:tesujimath/bash-env-nushell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jj.url = "github:jj-vcs/jj";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs: let
    findModulesList = import ./lib/find-modules-list.nix {inherit (inputs.nixpkgs) lib;};
  in
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux"];
      imports = builtins.concatMap findModulesList [./modules ./profiles ./hosts];
    };
}
