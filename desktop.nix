# Base module to be added to desktop systems
{
  pkgs,
  lib,
  config,
  defaultUser,
  userEmail,
  base16schemes,
  ...
}: let
  jetbrains-mono-nerdfont = pkgs.nerdfonts.override {
    fonts = [
      "JetBrainsMono"
    ];
  };

  lowBatteryNotifier =
    pkgs.writeScript "lowBatteryNotifier"
    ''
      BAT_PCT=`${pkgs.acpi}/bin/acpi -b | ${pkgs.gnugrep}/bin/grep -P -o '[0-9]+(?=%)'`
      BAT_STA=`${pkgs.acpi}/bin/acpi -b | ${pkgs.gnugrep}/bin/grep -P -o '\w+(?=,)'`
      echo "`date` battery status:$BAT_STA percentage:$BAT_PCT"
      test $BAT_PCT -le 10 && test $BAT_PCT -gt 5 && test $BAT_STA = "Discharging" && DISPLAY=:0.0 ${pkgs.libnotify}/bin/notify-send -c device -u normal   "Low Battery" "Would be wise to keep my charger nearby."
      test $BAT_PCT -le  5                        && test $BAT_STA = "Discharging" && DISPLAY=:0.0 ${pkgs.libnotify}/bin/notify-send -c device -u critical "Low Battery" "Charge me or watch me die!"
    '';
in {
  imports = [
    (import ./home-manager-desktop {
      user = defaultUser;
      inherit pkgs userEmail;
    })
  ];

  # For building Raspberry Pi images
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  services = {
    # Enable CUPS to print documents.
    printing.enable = lib.mkDefault true;
    avahi = {
      # To find network scanners
      enable = lib.mkDefault true;
      nssmdns = lib.mkDefault true;
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
    cron = {
      enable = true;
      systemCronJobs = [
        "* * * * * ${defaultUser} bash -x ${lowBatteryNotifier} > /tmp/cron.batt.log 2>&1"
      ];
    };
    slock-sleep = {
      description = "Lock X session using slock on sleep";
      before = ["sleep.target"];
      wantedBy = ["sleep.target"];
      User = defaultUser;
      Environment = "DISPLAY=:0";
      ExecStartPre = "xset dpms force suspend";
      ExecStart = "slock";
    };
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
    systemPackages = with pkgs;
      [
        neovide
        pcmanfm # File browser like Nautilus, but with no Gnome dependencies
        # yubioath-flutter # Yubico Authenticator Desktop app
        brave
        firefox
        joplin-desktop # Joplin (notes, desktop app)
        simplescreenrecorder
        inkscape-with-extensions
        gimp
        shutter # Screenshots
        signal-desktop
        gparted
        xcolor # Color picker
        skanlite # Lightweight sane frontend
        xsane # Sane frontend (advanced)
        koreader # ebook reader
        xournalpp # notetaking software with PDF annotation support
        texlive.combined.scheme-medium
        biber
        keepassxc
        # Nix
        alejandra # The uncompromising nix code formatter
        # Haskell
        ghc
        cabal-install
        cabal2nix
        # stack2nix # Broken
        # haskellPackages.summoner
        # haskellPackages.summoner-tui
        # haskellPackages.feedback # Declarative feedback loop manager
        hpack
        # Rust
        crate2nix
        #
        pandoc
        redshift # Blue light filter
        imagemagick
        nitrogen # Wallpaper browser/setter for X11
        jmtpfs # MTP (Android phone) support
        mpv-unwrapped # Media player
        mdp # A command-line based markdown presentation tool
        kcat # A generic non-JVM producer and consumer for Apache Kafka
        paperkey # Print OpenPGP or GnuPG on paper
        asciinema # Terminal session recoreder
        ovh-ttyrec # Terminal session recoreder
        ttygif # Convert ttyrec recordings to gif
        playerctl
        gh # GitHub CLI tool
        act # Run GitHub workflows locally
        arduino-cli
        element-desktop # Matrix client
        xscast # Screen cast for Xorg
      ]
      ++ (with fishPlugins; [
        fzf-fish
        done # Notifications when long background processes finish
      ]);
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

      sizes = {
        terminal = 16;
        applications = 14;
        desktop = 12;
      };
    };
    targets = {
      grub = {
        enable = false;
        # useImage = true;
      };
    };
  };

  xdg = import ./xdg;
}
