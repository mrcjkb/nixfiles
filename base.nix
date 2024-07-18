{
  pkgs,
  lib,
  defaultUser ? "mrcjk",
  userEmail ? "marc@jakobi.dev",
  nu-scripts,
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
      user = defaultUser;
      inherit
        pkgs
        userEmail
        nu-scripts
        ;
    })
  ];

  nix = let
    substituters = [
      "https://mrcjkb.cachix.org"
      "https://nix-community.cachix.org"
      "https://arm.cachix.org"
    ];
  in {
    package = lib.mkDefault pkgs.nixFlakes;
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
        efiSupport = lib.mkDefault true;
        device = "nodev";
      };
    };
    tmp = {
      cleanOnBoot = lib.mkDefault true;
    };
    supportedFilesystems = ["ntfs"];
    kernel.sysctl."kernel.sysrq" = 502;
  };

  fileSystems = {
    "/".options = ["noatime" "nodiratime"];
  };

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
      settings = {
        PasswordAuthentication = lib.mkDefault false;
        KbdInteractiveAuthentication = lib.mkDefault false;
      };
      extraConfig = ''
        AllowTcpForwarding yes
        X11Forwarding no
        AllowAgentForwarding no
        AllowStreamLocalForwarding no
        AuthenticationMethods publickey
      '';
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
    fwupd.enable = true;
  };

  hardware = {
    pulseaudio = {
      enable = lib.mkDefault true;
      extraConfig = "
        # Automatically switch audio to the connected bluetooth device when it connects.
        load-module module-switch-on-connect
      ";
    };
    bluetooth = {
      enable = lib.mkDefault true;
      settings = {
        General = {
          # Modern headsets will generally try to connect using the A2DP profile.
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
  };

  users = let
    defaultShell = pkgs.nushell;
  in {
    defaultUserShell = pkgs.zsh;
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
        "bluetooth"
      ];
      shell = defaultShell;
    };
  };

  environment = {
    sessionVariables = {
      XDG_CACHE_HOME = lib.mkDefault "\${HOME}/.cache";
      XDG_CONFIG_HOME = lib.mkDefault "\${HOME}/.config";
      XDG_BIN_HOME = lib.mkDefault "\${HOME}/.local/bin";
      XDG_DATA_HOME = lib.mkDefault "\${HOME}/.local/share";
      XDG_RUNTIME_DIR = lib.mkDefault "/run/user/1000";
      EDITOR = lib.mkDefault "nvim";
      BROWSER = lib.mkDefault "brave";
      TZ = lib.mkDefault "Europe/Berlin";
      # BAT_THEME = lib.mkDefault "Material-darker";
      SSH_AUTH_SOCK = lib.mkDefault "\${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh";
      PAGER = lib.mkDefault "nvimpager";
      NIX_AUTO_RUN = lib.mkDefault "1";
      NIX_PATH = lib.mkDefault "nixpkgs=flake:nixpkgs";
    };

    shells = with pkgs; [
      zsh
      nushell
    ];

    shellInit = ''
      export GPG_TTY="$(tty)"
      gpg-connect-agent /bye
    '';

    pathsToLink = [
      "/share/nix-direnv"
    ];

    # Rip out default packages like nano, perl and rsync
    defaultPackages = lib.mkForce [];

    systemPackages = with pkgs; let
      manix-fzf = pkgs.writeShellApplication {
        name = "nixf";
        runtimeInputs = [manix ripgrep fzf];
        text = "manix \"\" | rg '^# ' | sed 's/^# \\(.*\\) (.*/\\1/;s/ (.*//;s/^# //' | fzf --preview=\"manix '{}'\" | xargs manix";
      };
    in [
      # haskell-language-server
      haskellPackages.hoogle
      # haskellPackages.bhoogle # hoogle TUI
      nil
      # dhall-lsp-server
      # rust-analyzer
      git-filter-repo
      git-absorb # git commit --fixup, but automatic
      # git-mit # hooks to aid pairing and link commits to issues
      difftastic
      delta # A syntax-highlighting pager for git, diff, and grep output
      cachix # Nix package caching
      manix
      manix-fzf
      nix-diff # Explain why 2 nix derivations differ
      fzf
      ripgrep
      ripgrep-all # Also search in PDFs, e-books, zip, tar.gz, and more (with rga-fzf integration)
      fd
      tailspin # Log file highlighter
      odt2txt
      joplin # Joplin (notes) CLI client
      yubikey-manager # Yubico Authenticator CLI
      cht-sh # CLI client for cheat.sh, a community driven cheat sheet
      wget
      curl
      whois
      file
      moreutils
      neofetch # System information CLI
      zip
      unzip
      eza # Replacement for ls
      upower # D-Bus service for power management
      killall
      zoxide # Fast alternative to autojump and z-lua
      starship # Shell theme (nu, zsh, fish, ...)
      carapace # Multi-shell multi-command argument completer
      fish # Needed for nushell's fish_completer
      jq # JSON processor
      binutils # Tools for manipulating binaries
      dig # Domain information groper
      nmap
      update-systemd-resolved
      dconf # Required to set GTK theme in home-manager
      tokei # Count lines of code
      bottom # Alternative to htop
      du-dust # Alternative to du
      procs # Alternative to ps
      sd # Alternative to sed
      sad # Space Age seD
      bat
      ueberzugpp
      feh
      hyperfine # Alternative to time
      tealdeer # tldr implementation for simplified example based man pages
      grex # Generate regular expressions from user-provided test cases
      openssl
      usbutils
      nix-index # A files database for nix
      nixos-option
      direnv
      nix-direnv
      tmux-sessionizer # The fastest way to manage projects as tmux sessions
      zlib # Lossles data compression library
      pciutils # Inspection/manipulation of PCI devices
      bluetuith # Bluetooth TUI
      neo-cowsay
      dive # A tool for exploring each layer in a docker image
      (nvimpager.overrideAttrs (_: {
        doCheck = false;
      })) # Use neovim to view man pages, etc.
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = import ./programs {
    inherit pkgs;
  };

  virtualisation = {
    docker = {
      enable = lib.mkDefault true;
      autoPrune.enable = lib.mkDefault true;
      enableOnBoot = lib.mkDefault true;
    };
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
    # audit rules to log every single time a program is attempted to be run.
    # auditd.enable = lib.mkDefault true;
    audit = {
      enable = lib.mkDefault true;
      rules = [
        "-a exit,always -F arch=b64 -S execve"
      ];
    };
    sudo.execWheelOnly = lib.mkDefault true;
  };

  fonts = {
    fontDir.enable = lib.mkDefault true;
    enableGhostscriptFonts = lib.mkDefault true;
    packages = with pkgs; [
      jetbrains-mono-nerdfont
      roboto
      lato # Font used in tiko presentations, etc.
    ];
  };
}
