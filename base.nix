{ pkgs, home-manager, defaultUser ? "mrcjk", userEmail ? "mrcjkb89@outlook.com", ... }: 
let
in {

  imports = [ 
    (import ./xmonad-session { inherit pkgs; user = defaultUser; })
    (import ./searx.nix { package = pkgs.unstable.searx; })
    home-manager.nixosModule
    (import ./home-manager { pkgs = pkgs.unstable; user = defaultUser; inherit userEmail; })
  ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
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
    openssh.enable = true;
    onedrive.enable = true;
    upower.enable = true;
    gvfs.enable = true; # MTP support for PCManFM
    # Yubikey
    pcscd.enable = true;
    udev.packages = [ pkgs.yubikey-personalization ];
  };

  # Enable sound.
  sound.enable = true;
  hardware = {
    pulseaudio.enable = true;
    bluetooth.enable = true;
    sane = {
      enable = true; # Scanner support
      extraBackends = [ 
        pkgs.sane-airscan # Driverless scanning support
        # pkgs.hplipWithPlugin # HP support - requires allowUnfree = true
      ]; 
    };
  };

  users = {
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
      # RANGER_ZLUA = "${z-lua}/bin/z.lua"; # FIXME
      BAT_THEME = "Material-darker";
      OMF_CONFIG  = "\${XDG_CONFIG_HOME}/omf";
      SSH_AUTH_SOCK = "\${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh";
      WORKSPACE = "\${HOME}/.workspace";
      LIBSQLITE_CLIB_PATH = "${pkgs.sqlite.out}/lib/libsqlite3.so";
    };

    shellInit = ''
      export GPG_TTY="$(tty)"
      gpg-connect-agent /bye
    '';

    systemPackages = with pkgs; [
      (import (fetchGit "https://github.com/haslersn/fish-nix-shell"))
      # Create flakes-enabled alias for nix
      (pkgs.writeShellScriptBin "nixFlakes" ''
        exec ${pkgs.nixFlakes}/bin/nix --experimental-features "nix-command flakes" "$@"
      '')
      unstable.git-filter-repo
      cachix # Nix package caching
      gcc
      gnumake
      unstable.librsvg # Small SVG rendering library
      unstable.odt2txt
      unstable.pcmanfm # File browser like Nautilus, but with no Gnome dependencies
      unstable.keepassxc
      unstable.yubioath-desktop # Yubico Authenticator Desktop app
      unstable.brave
      unstable.firefox
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
      unstable.libsForQt5.filelight
      unstable.gparted
      unstable.xcolor # Color picker
      unstable.skanlite # Lightweight sane frontend
      unstable.xsane # Sane frontend (advanced)
      unstable.calibre # ebook reader
      unstable.xournalpp # notetaking software with PDF annotation support
      (unstable.python310.withPackages (pythonPackages: with pythonPackages; [
      ]))
      unstable.chrysalis # Kaleidoscope keyboard graphical frontend
      unstable.arduino-cli
      unstable.ninja # Small build system with a focus on speed (used to build sumneko-lua-language-server for nlua.nvim)
      texlive.combined.scheme-full
      biber
      # Haskell
      unstable.stack
      unstable.ghc
      unstable.cabal-install
      unstable.cabal2nix
      # stack2nix # Broken
      # haskellPackages.summoner
      # haskellPackages.summoner-tui
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
      # autojump # replaced with z-lua
      unstable.z-lua # Fast alternative to autojump
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
      unstable.gnupg
      pinentry-curses
      pinentry-qt
      paperkey
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    fish = {
      enable = true;
    };
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    ssh.startAgent = false; # Start ssh-agent as a systemd user service
    autojump.enable = true;
    git.enable = true;
    htop.enable = true;
    tmux.enable = true;
    traceroute.enable = true;
  };

  virtualisation.docker.enable = true;

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
