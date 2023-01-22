{
  pkgs,
  lib,
  config,
  defaultUser ? "mrcjk",
  userEmail ? "mrcjkb89@outlook.com",
  base16schemes,
  ...
}: let
  jetbrains-mono-nerdfont = pkgs.nerdfonts.override {
    fonts = [
      "JetBrainsMono"
    ];
  };
in {
  imports = [
    (import ./home-manager-base {
      pkgs = pkgs.unstable;
      user = defaultUser;
      inherit userEmail;
    })
  ];

  nix = let
    substituters = [
      "https://cache.iog.io"
      "https://mrcjkb.cachix.org"
      "https://shajra.cachix.org"
      "https://nix-community.cachix.org"
      "https://cache.garnix.io"
    ];
  in {
    package = pkgs.nixFlakes;
    extraOptions = ''
      allowed-uris = https://github.com
      auto-optimise-store = true
      keep-outputs = true
      keep-derivations = true
    '';
    # Binary Cache for Haskell.nix
    settings = {
      sandbox = lib.mkDefault true;
      inherit substituters;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [defaultUser];
      trusted-substituters = substituters;
      trusted-public-keys = [
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
        "mrcjkb.cachix.org-1:KhpstvH5GfsuEFOSyGjSTjng8oDecEds7rbrI96tjA4="
        "shajra.cachix.org-1:V0x7Wjgd/mHGk2KQwzXv8iydfIgLupbnZKLSQt5hh9o="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
    };
  };

  nixpkgs = {
    config = {
      allowBroken = lib.mkDefault true;
      packageOverrides = pkgs: {
        xsaneGimp = pkgs.xsane.override {gimpSupport = true;}; # Support for scanning in GIMP
        # NOTE: For GIMP scanning, a symlink must be created manually: ln -s /run/current-system/sw/bin/xsane ~/.config/GIMP/2.10/plug-ins/xsane
      };
    };
  };

  # Boot loader
  boot = {
    loader = {
      grub = {
        enable = lib.mkDefault true;
        version = 2;
        efiSupport = lib.mkDefault true;
        device = "nodev";
      };
    };
    cleanTmpDir = lib.mkDefault true;
    tmpOnTmpfs = lib.mkDefault true;
    supportedFilesystems = ["ntfs"];
  };

  fileSystems."/" = {options = ["noatime" "nodiratime"];};

  networking = {
    networkmanager.enable = lib.mkDefault true; # Enables wireless support via NetworkManager
    wireless.enable = lib.mkDefault false; # Disable wireless support via wpa_supplicant.
    firewall = {
      enable = lib.mkDefault true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
  };

  # disable coredump that could be exploited later
  # and also slow down the system when something crash
  systemd.coredump.enable = lib.mkDefault false;

  time.timeZone = "Europe/Zurich";

  # Internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services = {
    openssh = {
      enable = lib.mkDefault true;
    };
    upower.enable = lib.mkDefault true;
    # Yubikey
    pcscd.enable = lib.mkDefault true;
    udev.packages = [pkgs.yubikey-personalization];
    automatic-timezoned.enable = lib.mkDefault true;
    geoclue2.enable = lib.mkDefault true;
    clamav = {
      daemon.enable = true;
      updater.enable = true;
    };
  };

  # Disable sound (replaced with pipewire)
  sound.enable = lib.mkDefault false;
  hardware = {
    pulseaudio.enable = lib.mkDefault false;
    bluetooth = {
      enable = lib.mkDefault true;
    };
  };

  users = let
    defaultShell = pkgs.unstable.nushell;
  in {
    defaultUserShell = defaultShell;
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users."${defaultUser}" = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # Enable ‘sudo’ for the user.
        "networkmanager"
        "video"
        "docker"
        "scanner"
        "lp"
      ];
      shell = defaultShell;
    };
  };

  environment = {
    sessionVariables = {
      XDG_CACHE_HOME = "\${HOME}/.cache";
      XDG_CONFIG_HOME = "\${HOME}/.config";
      XDG_BIN_HOME = "\${HOME}/.local/bin";
      XDG_DATA_HOME = "\${HOME}/.local/share";
      XDG_RUNTIME_DIR = "/run/user/1000";
      EDITOR = "nvim";
      BROWSER = "firefox";
      TZ = "Europe/Berlin";
      BAT_THEME = "Material-darker";
      SSH_AUTH_SOCK = "\${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh";
      WORKSPACE = "\${HOME}/.workspace";
    };

    shells = with pkgs.unstable; [
      fish
      nushell
    ];

    shellInit = ''
      export GPG_TTY="$(tty)"
      gpg-connect-agent /bye
    '';

    pathsToLink = [
      "/share/nix-direnv"
    ];

    systemPackages = with pkgs; let
      manix-fzf = pkgs.writeShellApplication {
        name = "nixf";
        runtimeInputs = [unstable.manix unstable.ripgrep unstable.fzf];
        text = "manix \"\" | rg '^# ' | sed 's/^# \\(.*\\) (.*/\\1/;s/ (.*//;s/^# //' | fzf --preview=\"manix '{}'\" | xargs manix";
      };

      fish-nix-shell = import (fetchGit "https://github.com/haslersn/fish-nix-shell"); # TODO: Add flake.nix to fork

      haskell-tags-nix =
        (import (fetchGit {
            url = "https://github.com/shajra/haskell-tags-nix";
            ref = "main";
          }
          + "/default.nix"))
        .haskell-tags-nix-exe;
    in
      [
        fish-nix-shell
        haskell-tags-nix
        unstable.git-filter-repo
        cachix # Nix package caching
        unstable.manix
        manix-fzf
        gcc
        gnumake
        unstable.librsvg # Small SVG rendering library
        unstable.odt2txt
        unstable.joplin # Joplin (notes) CLI client
        unstable.yubikey-manager # Yubico Authenticator CLI
        unstable.signal-cli
        unstable.cht-sh # CLI client for cheat.sh, a community driven cheat sheet
        wget
        curl
        unstable.whois
        # unstable.silver-searcher # Fast search
        file
        unstable.moreutils
        unstable.neofetch # System information CLI
        # neomutt # E-mail
        zip
        unzip
        unstable.exa # Replacement for ls
        unstable.autorandr # Automatic XRandR configurations
        unstable.arandr # A simple visual front end for XRandR
        upower # D-Bus service for power management
        killall
        libnotify
        unstable.zoxide # Fast alternative to autojump and z-lua
        unstable.starship # Shell theme (fish, zsh, ...)
        unstable.jq # JSON processor
        # dpkg # For the interaction with .deb packages --> See https://reflexivereflection.com/posts/2015-02-28-deb-installation-nixos.html
        # patchelf # Determine/modify dynamic linker and RPATH of ELF executables
        unstable.binutils # Tools for manipulating binaries
        unstable.dig # Domain information groper
        nmap
        update-systemd-resolved
        unstable.dconf # Required to set GTK theme in home-manager
        unstable.pdftk # Command-line tool for working with PDFs
        unstable.tokei # Count lines of code
        unstable.bottom # Alternative to htop
        unstable.du-dust # Alternative to du
        unstable.procs # Alternative to ps
        unstable.sd # Alternative to sed
        unstable.hyperfine # Alternative to time
        unstable.tealdeer # tldr implementation for simplified example based man pages
        unstable.grex # Generate regular expressions from user-provided test cases
        openssl
        unstable.usbutils
        unstable.nix-output-monitor
        unstable.nix-index # A files database for nix
        unstable.direnv
        unstable.nix-direnv
        zlib # Lossles data compression library
        pciutils # Inspection/manipulation of PCI devices
        unstable.bluetuith # Bluetooth TUI
      ]
      ++ (import ./packages/fishPlugins.nix unstable.fishPlugins);
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = import ./programs {
    inherit pkgs userEmail;
    user = defaultUser;
  };

  virtualisation = {
    docker = {
      enable = lib.mkDefault true;
      autoPrune.enable = lib.mkDefault true;
      enableOnBoot = lib.mkDefault true;
    };
    libvirtd.enable = lib.mkDefault true;
  };

  security = {
    pam = {
      u2f.enable = lib.mkDefault true;
      yubico = {
        enable = lib.mkDefault true;
        debug = lib.mkDefault true;
        mode = "challenge-response";
      };
      services = {
        login.u2fAuth = lib.mkDefault true;
      };
    };
  };

  stylix = {
    image = pkgs.fetchurl {
      url = "https://user-images.githubusercontent.com/12857160/213937865-c910a41c-2092-48d1-83cc-e1776da0ec14.png";
      sha256 = "pnvx65H/OewNAodCiM3YB41+JzS+uYrS6o9xO4fJm+0=";
    };
    polarity = "dark";
    base16Scheme = "${base16schemes}/material-darker.yaml";
    fonts = {
      serif = {
        package = jetbrains-mono-nerdfont;
        name = "JetBrains Mono Nerd Font Mono";
      };

      sansSerif = {
        package = jetbrains-mono-nerdfont;
        name = "JetBrains Mono Nerd Font Mono";
      };

      monospace = {
        package = jetbrains-mono-nerdfont;
        name = "JetBrains Mono Nerd Font Mono";
      };

      emoji = {
        package = jetbrains-mono-nerdfont;
        name = "JetBrains Mono Nerd Font Mono";
      };
    };
  };

  fonts = {
    fontDir.enable = lib.mkDefault true;
    enableGhostscriptFonts = lib.mkDefault true;
    fonts = with pkgs; [
      jetbrains-mono-nerdfont
      roboto
      lato # Font used in tiko presentations, etc.
    ];
  };
}
