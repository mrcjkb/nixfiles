# Base module to be added to desktop systems
{
  pkgs,
  lib,
  config,
  defaultUser ? "mrcjk",
  userEmail ? "marc@jakobi.dev",
  ...
}: let
  jetbrains-mono-nerdfont = pkgs.nerdfonts.override {
    fonts = [
      "JetBrainsMono"
    ];
  };
in {
  imports = [
    (import ./home-manager-desktop {
      user = defaultUser;
      inherit pkgs userEmail;
    })
    ./modules/battery.nix
  ];

  nix.monitored = {
    enable = lib.mkDefault true;
    notify = lib.mkForce false;
  };

  # For building Raspberry Pi images
  boot = {
    binfmt.emulatedSystems = ["aarch64-linux"];
    plymouth.enable = lib.mkDefault false; # boot animation
  };

  services = {
    xserver = {
      xkb = {
        layout = lib.mkDefault "us";
        variant = lib.mkDefault "altgr-intl,";
      };
    };
    # Enable touchpad support
    libinput.enable = lib.mkDefault true;

    # Enable CUPS to print documents.
    printing.enable = lib.mkDefault true;
    avahi = {
      # To find network scanners
      enable = lib.mkDefault true;
      nssmdns4 = lib.mkDefault true;
    };
    onedrive = {
      enable = lib.mkDefault true;
    };
    gvfs.enable = lib.mkDefault true; # MTP support for PCManFM
    logind = {
      lidSwitch = "hybrid-sleep";
      lidSwitchExternalPower = "ignore";
      lidSwitchDocked = "lock";
      extraConfig = ''
        IdleAction=hybrid-sleep
        IdleActionSec=30min
        HandlePowerKey=suspend
        HandlePowerKeyLongPress=poweroff
      '';
    };
    blueman.enable = lib.mkDefault true;
    batteryNotifier.enable = lib.mkDefault true;
  };

  systemd.services.slock-sleep = {
    enable = true;
    description = "Lock X session using slock on sleep";
    before = ["sleep.target"];
    wantedBy = ["sleep.target"];
    serviceConfig.PassEnvironment = "DISPLAY";
    # preStart = "${pkgs.xorg.xset}/bin/xset dpms force suspend";
    script = "${pkgs.slock}/bin/slock";
  };

  hardware = {
    sane = {
      enable = lib.mkDefault true; # Scanner support
      extraBackends = [
        pkgs.sane-airscan # Driverless scanning support
        # pkgs.hplipWithPlugin # HP support - requires allowUnfree = true
      ];
    };
  };

  programs = import ./desktop-programs {
    inherit pkgs;
  };

  virtualisation = {
    libvirtd.enable = lib.mkDefault true;
  };

  environment = {
    systemPackages = with pkgs; [
      nix-output-monitor
      pcmanfm # File browser like Nautilus, but with no Gnome dependencies
      yubioath-flutter # Yubico Authenticator Desktop app
      librsvg # Small SVG rendering library
      brave
      firefox
      joplin-desktop # Joplin (notes, desktop app)
      simplescreenrecorder
      inkscape-with-extensions
      gimp
      shutter # Screenshots
      signal-cli
      signal-desktop
      autorandr # Automatic XRandR configurations
      arandr # A simple visual front end for XRandR
      libnotify
      pdftk # Command-line tool for working with PDFs
      xclip
      xcolor # Color picker
      skanlite # Lightweight sane frontend
      xsane # Sane frontend (advanced)
      koreader # ebook reader
      xournalpp # notetaking software with PDF annotation support
      keepassxc
      redshift # Blue light filter
      imagemagick
      ghostscript
      nitrogen # Wallpaper browser/setter for X11
      jmtpfs # MTP (Android phone) support
      mpv-unwrapped # Media player
      kcat # A generic non-JVM producer and consumer for Apache Kafka
      paperkey # Print OpenPGP or GnuPG on paper
      asciinema # Terminal session recoreder
      ovh-ttyrec # Terminal session recoreder
      ttygif # Convert ttyrec recordings to gif
      playerctl
      gh # GitHub CLI tool
      element-desktop # Matrix client
      overskride # bluetooth client UI
    ];
    sessionVariables = {
      # Workaround for cursor theme not being recognized
      XCURSOR_PATH = [
        "${config.system.path}/share/icons"
        "$HOME/.icons"
        "$HOME/.nix-profile/share/icons/"
      ];
      GTK_DATA_PREFIX = [
        "${config.system.path}"
      ];
    };
  };

  stylix = {
    enable = lib.mkDefault true;
    image = pkgs.fetchurl {
      url = "https://user-images.githubusercontent.com/12857160/213937865-c910a41c-2092-48d1-83cc-e1776da0ec14.png";
      sha256 = "pnvx65H/OewNAodCiM3YB41+JzS+uYrS6o9xO4fJm+0=";
    };
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/material-darker.yaml";
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

      sizes = {
        terminal = 16;
        applications = 14;
        desktop = 12;
      };
    };
    cursor = {
      name = "Volantes Material Dark";
      package = pkgs.volantes-cursors-material;
    };
    targets = {
      # NOTE: If a target does not exist, it belongs in home-manager-desktop/default.nix
      grub = {
        enable = true;
        # useImage = true;
      };
    };
  };

  xdg = import ./xdg;
}
