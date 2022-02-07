# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, vimUtils, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; }; # TODO: Fetch tarball
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  nixpkgs.config = {
    # Allow unfree/proprietary packages
    allowUnfree = true;
    # allowBroken = true;
    packageOverrides = pkgs: {
      # Nix User Repository
      nur = import (builtins.fetchTarball {
        # Choose the revision from https://github.com/nix-community/NUR/commits/master
        url = "https://github.com/nix-community/NUR/archive/94985a0cb2480bcae34203e6b855b2f068843246.tar.gz";
        # Get the hash by running `nix-prefetch-url --unpack <url>` on the above url
        sha256 = "0mb06d275y1jx1rys9m58xp7zi6r201i6m5haj322v5i3lda4zs4";
      }) {
        inherit pkgs;
      };
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
      # displayManager = {
      #   lightdm.enable = true;
      #   defaultSession = "none+xmonad";
      # };
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
        config = '' config /home/mrcjk/.sec/openvpn/marc.jakobi/ses-admin.ovpn ''; 
        updateResolvConf = true;
        autoStart = false;
      };
    };
    gvfs.enable = true; # MTP support for PCManFM
  };

  # Enable sound.
  sound.enable = true;
  hardware = {
    pulseaudio.enable = true;
    bluetooth.enable = true;
  };

  users = {
    defaultUserShell = pkgs.fish;
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.mrcjk = {
      isNormalUser = true;
      extraGroups = [ 
        "wheel" # Enable ‘sudo’ for the user. 
        "networkmanager"
        "video"
        "docker"
      ]; 
    };
  };

  home-manager = {
    users.mrcjk = {
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
              tool = "vscodium";
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
      cachix # Nix package caching
      unstable.neovim
      unstable.neovim-remote
      unstable.vimPlugins.packer-nvim
      tree-sitter # Required by Neovim
      gcc
      alacritty
      xterm # xmonad default terminal
      xmobar
      rofi
      ranger
      pcmanfm
      keepassxc
      brave
      firefox
      shutter # Screenshots
      simplescreenrecorder
      zoom-us
      slack
      teams
      jetbrains.idea-ultimate
      inkscape-with-extensions
      gimp
      libreoffice
      qemu
      virt-manager
      teamviewer
      vscodium
      pavucontrol
      libsForQt5.filelight
      gparted
      gpick
      skanlite
      xsane
      yed
      calibre # ebook reader
      (python310.withPackages (pythonPackages: with pythonPackages; [
        pynvim # Python NeoVim integration
        ueberzug # Image previews (used by rnvimr ranger plugin)
        json-rpc # Used by rnvimr ranger plugin
      ]))
      chrysalis # Kaleidoscope keyboard graphical frontend
      unstable.lua
      ninja # Small build system with a focus on speed (used to build sumneko-lua-language-server for nlua.nvim)
      docker
      texlive.combined.scheme-full
      biber
      # Haskell
      stack
      ghc
      cabal-install
      cabal2nix
      # stack2nix # Broken
      # haskellPackages.summoner
      # haskellPackages.summoner-tui
      haskellPackages.hoogle
      haskellPackages.implicit-hie ## Generate hie.yaml files with hie-gen
      haskell-language-server
      # Java
      # jdk8
      jdk11
      # Eclipse Java language server
      # (from mrcpkgs NUR package, managed by Marc Jakobi)
      nur.repos.mrcpkgs.eclipse-jdt-language-server
      #
      rnix-lsp # Nix language server
      nodePackages.pyright
      python-language-server
      sumneko-lua-language-server
      nodePackages.vim-language-server
      nodePackages.yaml-language-server
      nodePackages.dockerfile-language-server-nodejs
      rust-analyzer
      pandoc
      onedrive
      redshift
      ant
      maven
      gradle
      arduino-cli
      gh # GitHub CLI tool
      playerctl
      glow # Render markdown on the CLI
      imagemagick
      home-manager
      wget
      curl
      bat
      whois
      youtube-dl
      plantuml
      ripgrep # Fast (Rust) re-implementation of grep
      fd # Fast alternative to find
      silver-searcher
      neofetch
      neomutt
      ueberzug # Display images in terminal
      feh # Fast and light image viewer
      zip
      unzip
      exa
      nitrogen # Wallpaper browser/setter for X11
      autorandr # Automatic xrandr configurations
      picom # Compositor
      brightnessctl
      upower # D-Bus service for power management
      dmenu # Expected by xmonad
      gxmessage # Used by xmonad to show help
      fzf
      killall
      xorg.xkill
      libnotify
      autojump
      z-lua
      starship # Fish theme
      jq # JSON processor
      jmtpfs # MTP (Android phone) support
      dpkg # For the interaction with .deb packages --> See https://reflexivereflection.com/posts/2015-02-28-deb-installation-nixos.html
      patchelf # Determine/modify dynamic linker and RPATH of ELF executables
      binutils # Tools for manipulating binaries
      dig
      nmap
      update-systemd-resolved
      pscircle # Generate process tree visualizations
      xclip # Required so that neovim compiles with clipboard support
      dconf # Required to set GTK theme in home-manager
      nodejs
      nodePackages.yarn # Required by markdown-preview vim plugin
      haskellPackages.greenclip # Screenshots
      prometheus
      prometheus-node-exporter
      grafana
      vault
      sops
      git-crypt
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
    # ssh.startAgent = true; # Start ssh-agent as a systemd user service
    slock.enable = true;
    autojump.enable = true;
    git.enable = true;
    htop.enable = true;
    tmux.enable = true;
    traceroute.enable = true;
  };

  fonts.fonts = with pkgs; [
    nerdfonts
    jetbrains-mono
    roboto
  ];

  # Systemd services
  systemd.user.services."pscircle-feh" = {
    enable = true;
    description = "Generate a process tree wallpaper";
    wantedBy = [ "graphical.target" ];
    serviceConfig = {
      environment = "DISPLAY=:0";
      ExecStart = ''
        bash -c "while true; do pscircle --output=$HOME/pscircle.png && feh --bg-scale $HOME/pscircle.png; sleep 60; done"
      '';
    };
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
