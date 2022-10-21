{ pkgs, defaultUser ? "mrcjk", userEmail ? "mrcjkb89@outlook.com", ... }:
let
in {

  imports = [
    (import ./searx.nix { package = pkgs.unstable.searx; })
    (import ./home-manager { pkgs = pkgs.unstable; user = defaultUser; inherit userEmail; })
  ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      allowed-uris = https://github.com
      auto-optimise-store = true
    '';
    useSandbox = true;
    # Binary Cache for Haskell.nix
    settings = {
      substituters = [
        "https://cache.iog.io"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [defaultUser];
      trusted-substituters = [
        "https://cache.nixos.org"
        "https://iohk.cachix.org"
        "https://hydra.iohk.io"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      ];
    };
  };

  nixpkgs = {
    config = {
      packageOverrides = pkgs: {
        xsaneGimp = pkgs.xsane.override { gimpSupport = true; }; # Support for scanning in GIMP
        # NOTE: For GIMP scanning, a symlink must be created manually: ln -s /run/current-system/sw/bin/xsane ~/.config/GIMP/2.10/plug-ins/xsane
      };
    };
  };

  # Boot loader
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        # Disallow editing the kernel command-line befor boot
        # Enabling this allows gaining root access by passing init=/bin/sh as a kernel parameter
        editor = false;
        # Maximum number of latest generations in the boot menu.
        configurationLimit = 50;
      };
    };
    cleanTmpDir = true;
    tmpOnTmpfs = true;
  };

  networking.networkmanager.enable = true; # Enables wireless support via NetworkManager
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  time.timeZone = "Europe/Amsterdam";

  # Internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  console = { font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services = {
    # Enable CUPS to print documents.
    printing.enable = true;
    avahi = { # To find network scanners
      enable = true;
      nssmdns = true;
    };
    openssh = {
      enable = true;
    };
    onedrive = {
      enable = true;
      package = pkgs.unstable.onedrive;
    };
    upower.enable = true;
    gvfs.enable = true; # MTP support for PCManFM
    # Yubikey
    pcscd.enable = true;
    udev.packages = [ pkgs.yubikey-personalization ];
    localtime.enable = true;
    logind.lidSwitch = "ignore";
  };

  # Disable sound (replaced with pipewire)
  sound.enable = false;
  hardware = {
    pulseaudio.enable = false;
    bluetooth.enable = true;
    sane = {
      enable = true; # Scanner support
      extraBackends = [
        pkgs.sane-airscan # Driverless scanning support
        # pkgs.hplipWithPlugin # HP support - requires allowUnfree = true
      ];
    };
  };

  users = let
    defaultShell = pkgs.unstable.fish;
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
    sessionVariables = rec {
      XDG_CACHE_HOME = "\${HOME}/.cache";
      XDG_CONFIG_HOME = "\${HOME}/.config";
      XDG_BIN_HOME = "\${HOME}/.local/bin";
      XDG_DATA_HOME = "\${HOME}/.local/share";
      XDG_RUNTIME_DIR = "/run/user/1000";
      EDITOR = "nvim";
      BROWSER = "brave";
      TZ = "Europe/Berlin";
      BAT_THEME = "Material-darker";
      OMF_CONFIG  = "\${XDG_CONFIG_HOME}/omf";
      SSH_AUTH_SOCK = "\${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh";
      WORKSPACE = "\${HOME}/.workspace";
    };

    shellInit = ''
      export GPG_TTY="$(tty)"
      gpg-connect-agent /bye
    '';


    systemPackages = with pkgs; let

      manix-fzf = pkgs.writeShellApplication ({
        name = "nixf";
        runtimeInputs = [unstable.manix unstable.ripgrep unstable.fzf];
        text = "manix \"\" | rg '^# ' | sed 's/^# \\(.*\\) (.*/\\1/;s/ (.*//;s/^# //' | fzf --preview=\"manix '{}'\" | xargs manix";
      });

      system-update-wrapper = writeShellApplication {
        name = "nixos-update";
        text = ''
          if [ "$BASENIXFILESREPO" == "" ]; then
            >&2 echo "error: BASENIXFILESREPO not set."
            exit 1
          fi
          if [[ ! -d "$BASENIXFILESREPO" ]]; then
            >&2 echo "error: $BASENIXFILESREPO not found."
            exit 1
          fi
          if [ "$NIXOSREPO" == "" ]; then
            >&2 echo "error: NIXOSREPO not set."
            exit 1
          fi
          if [[ ! -d "$NIXOSREPO" ]]; then
            >&2 echo "error: $NIXOSREPO not found."
            exit 1
          fi

          pushd "$BASENIXFILESREPO"
          git pull
          nix flake update --commit-lock-file && git push
          popd
          pushd "$NIXOSREPO"
          git pull
          nix flake update --commit-lock-file && git push
          popd
          sudo nixos-rebuild switch --flake "$NIXOSREPO" --impure "$@"
        '';
      };

    in [
      system-update-wrapper
      (import (fetchGit "https://github.com/haslersn/fish-nix-shell"))
      unstable.git-filter-repo
      cachix # Nix package caching
      unstable.manix
      manix-fzf
      gcc
      gnumake
      unstable.librsvg # Small SVG rendering library
      unstable.odt2txt
      unstable.pcmanfm # File browser like Nautilus, but with no Gnome dependencies
      unstable.keepassxc
      unstable.yubioath-desktop # Yubico Authenticator Desktop app
      brave
      unstable.firefox-bin
      unstable.joplin # Joblin (notes) CLI client
      unstable.joplin-desktop # Joblin (notes, desktop app)
      unstable.yubikey-manager # Yubico Authenticator CLI
      unstable.shutter # Screenshots
      unstable.simplescreenrecorder
      unstable.inkscape-with-extensions
      unstable.gimp
      unstable.wireshark
      unstable.signal-desktop
      unstable.signal-cli
      unstable.cht-sh # CLI client for cheat.sh, a community driven cheat sheet
      unstable.gparted
      unstable.xcolor # Color picker
      unstable.skanlite # Lightweight sane frontend
      unstable.xsane # Sane frontend (advanced)
      unstable.koreader # ebook reader
      unstable.xournalpp # notetaking software with PDF annotation support
      (unstable.python310.withPackages (pythonPackages: with pythonPackages; [
      ]))
      unstable.chrysalis # Kaleidoscope keyboard graphical frontend
      unstable.arduino-cli
      texlive.combined.scheme-full
      biber
      # Haskell
      unstable.stack
      unstable.ghc
      unstable.cabal-install
      unstable.cabal2nix
      # stack2nix # Broken
      # unstable.haskellPackages.summoner
      # unstable.haskellPackages.summoner-tui
      unstable.hpack
      # Rust
      unstable.crate2nix
      unstable.ruby
      unstable.pandoc
      unstable.redshift # Blue light filter
      unstable.gh # GitHub CLI tool
      unstable.playerctl
      unstable.imagemagick
      wget
      curl
      unstable.whois
      unstable.youtube-dl
      unstable.plantuml
      unstable.silver-searcher # Fast search
      file
      unstable.moreutils
      unstable.neofetch # System information CLI
      # neomutt # E-mail
      zip
      unzip
      unstable.exa # Replacement for ls
      unstable.nitrogen # Wallpaper browser/setter for X11
      unstable.autorandr # Automatic XRandR configurations
      unstable.arandr # A simple visual front end for XRandR
      upower # D-Bus service for power management
      killall
      libnotify # Desktop notifications
      unstable.zoxide # Fast alternative to autojump and z-lua
      unstable.starship # Fish theme
      unstable.jq # JSON processor
      unstable.jmtpfs # MTP (Android phone) support
      # dpkg # For the interaction with .deb packages --> See https://reflexivereflection.com/posts/2015-02-28-deb-installation-nixos.html
      # patchelf # Determine/modify dynamic linker and RPATH of ELF executables
      unstable.binutils # Tools for manipulating binaries
      unstable.dig # Domain information groper
      nmap
      update-systemd-resolved
      unstable.dconf # Required to set GTK theme in home-manager
      unstable.mpv-unwrapped # Media player
      unstable.pdftk # Command-line tool for working with PDFs
      unstable.cloc # Count lines of code
      unstable.mdp # A command-line based markdown presentation tool
      unstable.kcat # A generic non-JVM producer and consumer for Apache Kafka
      # A library for storing and retrieving passwords and other secrets
      # (secret-tool can be used to look up secrets from the keyring)
      openssl
      unstable.usbutils
      paperkey
      unstable.nix-output-monitor
      zlib # Lossles data compression library
      unstable.asciinema # Terminal session recoreder
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    fish = {
      enable = true;
      shellAliases = {
        cd = "z";
        bd = "prevd";
        nd = "nextd";
        exa = "exa --icons --git";
        ls = "exa --icons --git";
        la = "exa --icons --git -a";
        ll = "ls --icons --git -l";
        lt = "ls --icons --tree";
        ltg = "lt --git";
        lta = "lt -a";
        ltl = "lt -l";
        lla = "ls --icons --git -al";
        grep = "rg";
        cat = "bat --style=plain";
        mkdir = "mkdir -p";
        # For managing dotfiles, see: https://www.atlassian.com/git/tutorials/dotfiles
        config = "git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME";
      };
    };
    mtr.enable = true;
    gnupg = {
      package = pkgs.unstable.gnupg;
      agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };
    ssh = {
      startAgent = false; # Start ssh-agent as a systemd user service
      knownHosts = {
        "github.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      };
    };
    autojump.enable = true;
    git.enable = true;
    htop.enable = true;
    tmux.enable = true;
    traceroute.enable = true;
  };

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };

  security = {
    pam = {
      u2f.enable = true;
      yubico = {
        enable = true;
        debug = true;
        mode = "challenge-response";
      };
      services = {
        login.u2fAuth = true;
      };
    };
  };

  fonts.fonts = with pkgs; [
    nerdfonts
    jetbrains-mono
    roboto
    lato # Font used in tiko presentations, etc.
  ];

}
