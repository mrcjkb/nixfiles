# Edit this configuration file to define what should be installed on

# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, vimUtils, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  unstable = import <nixos-unstable> {/*  config = { allowUnfree = true; };  */}; # TODO: Fetch tarball
  defaultUser = "mrcjk"; # Default user account
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  nixpkgs.config = {
    # Allow unfree/proprietary packages
    # allowUnfree = true;
    # allowBroken = true;
    packageOverrides = pkgs: {
      # Nix User Repository
      nur = import (builtins.fetchTarball {
        # Choose the revision from https://github.com/nix-community/NUR/commits/master
        url = "https://github.com/nix-community/NUR/archive/656fcff0df4dcfe6b2a1222853d3939e0689660f.tar.gz";
        # Get the hash by running `nix-prefetch-url --unpack <url>` on the above url
        sha256 = "17awz985jh51v8v83gpa746c5ph50c3aqlvi6vs858p4q25inc1i";
      }) {
        inherit pkgs;
      };
      xsaneGimp = pkgs.xsane.override { gimpSupport = true; }; # Support for scanning in GIMP
      # NOTE: For GIMP scanning, a symlink must be created manually: ln -s /run/current-system/sw/bin/xsane ~/.config/GIMP/2.10/plug-ins/xsane
    };
  };

  # Boot loader
  boot.loader = {
    systemd-boot.enable = true;
    #grub.enable = true;
    #grub.version = 2;
    # grub.efiSupport = true;
    # grub.efiInstallAsRemovable = true;
    # efi.efiSysMountPoint = "/boot/efi";
    # Define on which hard drive you want to install Grub.
    #grub.device = "/dev/sda"; # or "nodev" for efi only
  };

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true; # Enables wireless support via NetworkManager
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.interfaces.enp4s0.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  console = { font = "Lat2-Terminus16";
    keyMap = "us";
  };



  services = {
    xserver = { 
      # Enable the X11 windowing system.
      enable = true;
      # Configure keymap in X11
      layout = "us";
      xkbVariant = "altgr-intl";
      # xkbOptions = "eurosign:e";
      # Enable the GNOME Desktop Environment.
      # desktopManager.gnome.enable = true;
      displayManager = {
        lightdm = {
          enable = true;
          greeters.mini = {
            enable = true;
            user = defaultUser;
            extraConfig = ''
              [greeter]
              show-password-label = false
              [greeter-theme]
              background-image = ""
            '';
          };
        };
        defaultSession = "none+xmonad";
      };
      windowManager = {
        xmonad = {
          enable = true;
          enableContribAndExtras = true;
          extraPackages = hpkgs: [
            hpkgs.xmonad
            hpkgs.xmonad-contrib
            hpkgs.xmonad-extras
          ];
        };
      };
      # Enable touchpad support (enabled default in most desktopManager).
      libinput.enable = true;
    };
    # Enable blueman if the DE does not provide a bluetooth management GUI.
    blueman.enable = true;
    # Enable CUPS to print documents.
    printing.enable = true;
    openssh = {
      enable = true;
      passwordAuthentication = false;
    };
    onedrive.enable = true;
    upower.enable = true;
    openvpn.servers = {
      officeVPN = { 
        config = '' config /home/${defaultUser}/.sec/openvpn/marc.jakobi/ses-admin.ovpn ''; 
        updateResolvConf = true;
        autoStart = false;
      };
    };
    gvfs.enable = true; # MTP support for PCManFM
    avahi = { # To find network scanners
      enable = true;
      nssmdns = true;
    };
    # Yubikey
    pcscd.enable = true;
    udev.packages = [ pkgs.yubikey-personalization ];
    searx = {
      enable = true;
      settings = {
        use_default_settings = true;
        general = {
          instance_name = "Marc's searx";
        };
        search = {
          safe_search = 1; # 0 = None, 1 = Moderate, 2 = Strict
          autocomplete = "google"; # Existing autocomplete backends: "dbpedia", "duckduckgo", "google", "startpage", "swisscows", "qwant", "wikipedia" - leave blank to turn it off by default
          default_lang = "en";
        };
        server = {
          secret_key = "U-ON-SJ[crJCwUb!#&bQ)00aI3|7\'L9hpQUoLtk$vr9\"xME|NS7Ptm@J\>sj=0W";
        };
        ui = {
          default_theme = "oscar";
          default_locale = "en";
        };
        outgoing = {
          request_timeout = 10.0;
        };
        engines = [
          {
            name = "archwiki";
            engine = "archlinux";
            shortcut = "aw";
          }
          {
            name = "wikipedia";
            engine = "wikipedia";
            shortcut = "w";
            base_url = "https://wikipedia.org/";
          }
          {
            name = "duckduckgo";
            engine = "duckduckgo";
            shortcut = "ddg";
          }
          {
            name = "github";
            engine = "github";
            shortcut = "gh";
          }
          {
            name = "google";
            engine = "google";
            shortcut = "g";
            use_mobile_ui = false;
          }
          {
            name = "hoogle";
            engine = "xpath";
            search_url = "https://hoogle.haskell.org/?hoogle={query}&start={pageno}";
            results_xpath = "//div[@class=\"result\"]";
            title_xpath = "./div[@class=\"ans\"]";
            url_xpath = "./div[@class=\"ans\"]//a/@href";
            content_xpath = "./div[contains(@class, \"doc\")]";
            categories = "it";
            shortcut = "h";
          }
        ];
      };
    };
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

  home-manager = {
    users."${defaultUser}" = {
      programs = {
        git = {
          enable = true;
          userName = "Marc Jakobi";
          userEmail = "marc.jakobi@tiko.energy";
          signing = {
            key = "F31C0D0D5BBB0289";
          };
          aliases = {
            config = "git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME";
          };
          extraConfig = {
            merge = {
              tool = "codium";
            };
            pull = {
              rebase = true;
            };
            # Force SSH instead of HTTPS:
            # url."ssh://git@github.com/".insteadOf = "https://github.com/";
          };
        };
      };
      gtk = {
        enable = true;
        theme = {
          name = "Materia-dark";
          package = pkgs.materia-theme;
        };
        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.papirus-icon-theme;
        };
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {

    systemPackages = with pkgs; [
      (import (fetchGit "https://github.com/haslersn/fish-nix-shell"))
      # Create flakes-enabled alias for nix
      (pkgs.writeShellScriptBin "nixFlakes" ''
        exec ${pkgs.nixFlakes}/bin/nix --experimental-features "nix-command flakes" "$@"
      '')
      cachix # Nix package caching
      unstable.neovim
      unstable.neovim-remote
      unstable.vimPlugins.packer-nvim
      unstable.tree-sitter # Required by Neovim
      gcc
      gnumake
      alacritty
      xterm # xmonad default terminal
      unstable.xmobar
      unstable.rofi
      unstable.ranger # TUI file browser
      librsvg # Small SVG rendering library
      odt2txt
      unstable.pcmanfm # File browser like Nautilus, but with no Gnome dependencies
      unstable.keepassxc
      unstable.brave
      unstable.firefox
      unstable.joplin # Joblin (notes) CLI client
      unstable.joplin-desktop # Joblin (notes, desktop app)
      yubioath-desktop # Yubico Authenticator Desktop app
      yubikey-manager # Yubico Authenticator CLI
      unstable.shutter # Screenshots
      unstable.simplescreenrecorder
      unstable.inkscape-with-extensions
      unstable.gimp
      unstable.signal-desktop
      unstable.signal-cli
      unstable.searx
      # unstable.libreoffice
      # qemu
      # virt-manager
      # unstable.vscodium
      pavucontrol # PulseAudio volume control
      libsForQt5.filelight
      gparted
      xcolor # Color picker
      skanlite # Lightweight sane frontend
      xsane # Sane frontend (advanced)
      calibre # ebook reader
      (unstable.python310.withPackages (pythonPackages: with pythonPackages; [
        # ueberzug # Image previews (used by rnvimr ranger plugin)
      ]))
      chrysalis # Kaleidoscope keyboard graphical frontend
      (unstable.lua.withPackages (luapkgs: with luapkgs; [
        luacheck
        plenary-nvim
        luacov
      ]))
      unstable.ninja # Small build system with a focus on speed (used to build sumneko-lua-language-server for nlua.nvim)
      docker
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
      unstable.haskellPackages.hoogle
      unstable.haskellPackages.implicit-hie ## Generate hie.yaml files with hie-gen
      unstable.haskell-language-server
      niv # Easy dependency management for Nix projects
      # Rust
      unstable.rust-analyzer
      unstable.crate2nix
      # Java
      # jdk8
      jdk11
      #
      rnix-lsp # Nix language server
      unstable.nodePackages.pyright
      unstable.python-language-server
      unstable.sumneko-lua-language-server
      unstable.nodePackages.vim-language-server
      unstable.nodePackages.yaml-language-server
      unstable.nodePackages.dockerfile-language-server-nodejs
      unstable.pandoc
      onedrive
      redshift # Blue light filter
      # ant
      # maven
      # gradle
      arduino-cli
      unstable.gh # GitHub CLI tool
      playerctl
      unstable.glow # Render markdown on the command-line
      imagemagick
      home-manager
      wget
      curl
      bat # cat with syntax highlighting
      whois
      youtube-dl
      plantuml
      unstable.ripgrep # Fast (Rust) re-implementation of grep
      unstable.fd # Fast alternative to find
      silver-searcher # Fast search
      file
      moreutils
      neofetch # System information CLI
      # neomutt # E-mail 
      unstable.ueberzug # Display images in terminal
      unstable.feh # Fast and light image viewer
      zip
      unzip
      unstable.exa # Replacement for ls
      nitrogen # Wallpaper browser/setter for X11
      autorandr # Automatic XRandR configurations
      arandr # A simple visual front end for XRandR
      picom # Compositor
      brightnessctl # Brightness control CLI
      upower # D-Bus service for power management
      dmenu # Expected by xmonad
      unstable.gxmessage # Used by xmonad to show help
      unstable.fzf # Fuzzy search
      killall
      xorg.xkill # Kill X windows with the cursor
      libnotify # Desktop notifications
      # autojump # replaced with z-lua
      unstable.z-lua # Fast alternative to autojump
      unstable.starship # Fish theme
      jq # JSON processor
      jmtpfs # MTP (Android phone) support
      # dpkg # For the interaction with .deb packages --> See https://reflexivereflection.com/posts/2015-02-28-deb-installation-nixos.html
      # patchelf # Determine/modify dynamic linker and RPATH of ELF executables
      binutils # Tools for manipulating binaries
      dig # Domain information groper
      nmap
      update-systemd-resolved
      pscircle # Generate process tree visualizations
      xclip # Required so that neovim compiles with clipboard support
      dconf # Required to set GTK theme in home-manager
      unstable.nodejs
      unstable.nodePackages.yarn # Required by markdown-preview vim plugin
      unstable.haskellPackages.greenclip # Clipboard manager for use with rofi
      unstable.scrot # A command-line screen capture utility
      mpv-unwrapped # Media player
      pdftk # Command-line tool for working with PDFs
      cloc # Count lines of code
      mdp # A command-line based markdown presentation tool
      kcat # A generic non-JVM producer and consumer for Apache Kafka
      # A library for storing and retrieving passwords and other secrets
      # (secret-tool can be used to look up secrets from the keyring)
      openssl
      usbutils
      gnupg
      pinentry-curses
      pinentry-qt
      paperkey
      #### NUR packages ###
      # Eclipse Java language server
      # (from mrcpkgs NUR package, managed by Marc Jakobi)
      # XXX Note: It may be necessary to update the nur tarball if a package is not found.
      nur.repos.mrcpkgs.eclipse-jdt-language-server
      nur.repos.mrcpkgs.yubikee-smartvpn # Automate SmartVPN login with YubiKey OAuth
      nur.repos.mrcpkgs.nextcloud-no-de # nextcloud-client wrapper that waits for KeePass Secret Service Integration
      # tiko-related
      vault
      sops
      git-crypt
      # Useful for development - experimentation
      prometheus
      prometheus-node-exporter
      grafana
      # Unfree software
      # yed 
      # zoom-us
      # slack
      # teams # The Linux version of Teams seems to have some issues. Better to use the browser version.
      # jetbrains.idea-ultimate
      # teamviewer
      # end of package list
    ];
    sessionVariables = rec {
      XDG_CACHE_HOME = "\${HOME}/.cache";
      XDG_CONFIG_HOME = "\${HOME}/.config";
      XDG_BIN_HOME = "\${HOME}/.local/bin";
      XDG_DATA_HOME = "\${HOME}/.local/share";
      XDG_RUNTIME_DIR = "/run/user/1000";
      EDITOR = "nvim";
      BROWSER = "brave";
      TZ = "Europe/Berlin";
      VAULT_ADDR = "https://vault.internal.tiko.ch";
      # RANGER_ZLUA = "${z-lua}/bin/z.lua"; # FIXME
      BAT_THEME = "Material-darker";
      GRADLE_HOME = "\${HOME}/.gradle";
      OMF_CONFIG  = "\${XDG_CONFIG_HOME}/omf";
      SSH_AUTH_SOCK = "\${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh";
      WORKSPACE = "\${HOME}/.workspace";
    };

    shellInit = ''
      export GPG_TTY="$(tty)"
      gpg-connect-agent /bye
    '';
  };

  nixpkgs.overlays = [
   (self: super: {
     neovim = super.neovim.override {
       viAlias = true;
       vimAlias = true;
     };
   })
 ];


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
    slock.enable = true;
    autojump.enable = true;
    git.enable = true;
    htop.enable = true;
    tmux.enable = true;
    traceroute.enable = true;
  };

  security.pam = {
    u2f.enable = true;
    yubico = {
     enable = true;
     debug = true;
     mode = "challenge-response";
   };
   services = {
     login.u2fAuth = true;
     slock.u2fAuth = true;
   };
 };

  fonts.fonts = with pkgs; [
    nerdfonts
    jetbrains-mono
    roboto
    lato # Font used in tiko presentations, etc.
  ];

  # Binary Cache for Haskell.nix
  # Note: To nixos-rebuild, pass `--opton substitue false` when not connected to Tiko VPN
  nix = {
    binaryCaches = [ 
      "https://cache.nixos.org"
      "https://iohk.cachix.org"
      "s3://tiko-nix-cache?region=eu-central-1"
      "http://hydra.tiko.ch/"
      "https://hydra.iohk.io"
    ];
    binaryCachePublicKeys = [
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "hydra.tiko.ch:q8EX+cmvjysdFOPttZEl30cMv5tnB2dddkwrC61qdA4="
      "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    ];
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.epnable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}
