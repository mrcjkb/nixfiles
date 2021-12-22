# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, vimUtils, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
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
#  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp3s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "Lat2-Terminus16";
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
        lightdm.enable = true;
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
    # Enable CUPS to print documents.
    printing.enable = true;
    openssh = {
      enable = true;
      passwordAuthentication = false;
    };
    onedrive.enable = true;
    upower.enable = true;
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users = {
    defaultUserShell = pkgs.fish;
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.mrcjk = {
      isNormalUser = true;
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    };
  };

  home-manager.users.mrcjk = {
    programs = {
      git = {
        enable = true;
        userName = "Marc Jakobi";
        userEmail = "mrcjkb89@outlook.com";
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      neovim
      neovim-remote
      vimPlugins.packer-nvim
      alacritty
      xterm # xmonad default terminal
      xmobar
      rofi
      ranger
      pcmanfm
      keepassxc
      brave
      shutter # Screenshots
      simplescreenrecorder
      zoom-us
      jetbrains.idea-ultimate
      inkscape-with-extensions
      gimp
      libreoffice
      virt-manager
      nextcloud-client
      teamviewer
      vscodium
      blueman
      libsForQt5.filelight
      gparted
      gpick
      skanlite
      xsane
      yed
      calibre # ebook reader
      chrysalis # Kaleidoscope keyboard graphical frontend
      python310
      lua
      docker
      texlive.combined.scheme-full
      biber
      stack
      ghc
      cabal-install
      cabal2nix
      # stack2nix # Broken
      # haskellPackages.summoner
      # haskellPackages.summoner-tui
      haskellPackages.hoogle
      haskell-language-server
      rnix-lsp
      python-language-server
      sumneko-lua-language-server
      nodePackages.vim-language-server
      nodePackages.yaml-language-server
      nodePackages.dockerfile-language-server-nodejs
      nodePackages.pyright
      rust-analyzer
      pandoc
      onedrive
      redshift
      rofi
      ant
      maven
      gradle
      arduino-cli
      gh # GitHub CLI tool
      bluez
      playerctl
      glow # Render markdown on the CLI
      imagemagick
      home-manager
      wget
      bat
      whois
      youtube-dl
      plantuml
      ripgrep
      silver-searcher
      neofetch
      neomutt
      ueberzug
      zip
      unzip
      exa
      qemu
      feh
      curl
      nitrogen
      autorandr
      picom
      brightnessctl
      autorandr
      upower
      dmenu # Expected by xmonad
      fzf
      autojump
      starship
      jq
    ];
    variables = {
      EDITOR = "nvim";
      XDG_RUNTIME_DIR = "/run/user/${builtins.toString config.users.users.mrcjk.uid}";
      XDG_RUNTIIME_DIR = "/run/user/${builtins.toString config.users.users.mrcjk.uid}";
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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

