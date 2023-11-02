{
  pkgs,
  lib,
  defaultUser ? "mrcjk",
  userEmail ? "mrcjkb89@outlook.com",
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
      inherit pkgs userEmail;
    })
  ];

  nix = let
    substituters = [
      "https://mrcjkb.cachix.org"
      "https://nix-community.cachix.org"
      "https://arm.cachix.org"
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
      useTmpfs = lib.mkDefault true;
      cleanOnBoot = lib.mkDefault true;
    };
    supportedFilesystems = ["ntfs"];
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
  };

  sound.enable = lib.mkDefault true;
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
    defaultUserShell = pkgs.fish;
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
      BROWSER = "brave";
      TZ = "Europe/Berlin";
      # BAT_THEME = "Material-darker";
      SSH_AUTH_SOCK = "\${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh";
      WORKSPACE = "\${HOME}/.workspace";
      PAGER = "nvimpager";
    };

    shells = with pkgs; [
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

    # Rip out default packages like nano, perl and rsync
    defaultPackages = lib.mkForce [];

    systemPackages = with pkgs; let
      manix-fzf = pkgs.writeShellApplication {
        name = "nixf";
        runtimeInputs = [manix ripgrep fzf];
        text = "manix \"\" | rg '^# ' | sed 's/^# \\(.*\\) (.*/\\1/;s/ (.*//;s/^# //' | fzf --preview=\"manix '{}'\" | xargs manix";
      };
    in
      [
        # haskell-language-server
        haskellPackages.hoogle
        nil
        # dhall-lsp-server
        # rust-analyzer
        lldb # for DAP
        texlab
        git-filter-repo
        cachix # Nix package caching
        manix
        manix-fzf
        nix-diff # Explain why 2 nix derivations differ
        nixpkgs-review
        fzf
        ripgrep
        fd
        gcc
        gnumake
        librsvg # Small SVG rendering library
        odt2txt
        joplin # Joplin (notes) CLI client
        yubikey-manager # Yubico Authenticator CLI
        signal-cli
        cht-sh # CLI client for cheat.sh, a community driven cheat sheet
        carapace # Multi-shell multi-command argument completer
        wget
        curl
        whois
        # silver-searcher # Fast search
        file
        moreutils
        neofetch # System information CLI
        # neomutt # E-mail
        zip
        unzip
        eza # Replacement for ls
        autorandr # Automatic XRandR configurations
        arandr # A simple visual front end for XRandR
        upower # D-Bus service for power management
        killall
        libnotify
        zoxide # Fast alternative to autojump and z-lua
        starship # Shell theme (fish, zsh, ...)
        jq # JSON processor
        # dpkg # For the interaction with .deb packages --> See https://reflexivereflection.com/posts/2015-02-28-deb-installation-nixos.html
        # patchelf # Determine/modify dynamic linker and RPATH of ELF executables
        binutils # Tools for manipulating binaries
        dig # Domain information groper
        nmap
        update-systemd-resolved
        dconf # Required to set GTK theme in home-manager
        pdftk # Command-line tool for working with PDFs
        tokei # Count lines of code
        bottom # Alternative to htop
        du-dust # Alternative to du
        procs # Alternative to ps
        sd # Alternative to sed
        sad # Space Age seD
        bat
        ueberzug
        feh
        xclip
        hyperfine # Alternative to time
        tealdeer # tldr implementation for simplified example based man pages
        grex # Generate regular expressions from user-provided test cases
        openssl
        usbutils
        nix-output-monitor
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
      ]
      ++ (with fishPlugins; [
        bass # `bass source` bash scripts
        autopair-fish
      ]);
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
    auditd.enable = lib.mkDefault true;
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
