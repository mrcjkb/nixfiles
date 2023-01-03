# Base module to be added to desktop systems
{
  pkgs,
  lib,
  config,
  defaultUser,
  userEmail,
  ...
}: {
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
      package = pkgs.unstable.onedrive;
    };
    gvfs.enable = lib.mkDefault true; # MTP support for PCManFM
    logind.lidSwitch = "ignore";
    blueman.enable = lib.mkDefault true;
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

  environment = {
    systemPackages = with pkgs; [
      unstable.pcmanfm # File browser like Nautilus, but with no Gnome dependencies
      unstable.yubioath-flutter # Yubico Authenticator Desktop app
      unstable.brave
      unstable.firefox
      unstable.joplin-desktop # Joplin (notes, desktop app)
      unstable.simplescreenrecorder
      unstable.inkscape-with-extensions
      unstable.gimp
      unstable.shutter # Screenshots
      unstable.signal-desktop
      unstable.gparted
      unstable.xcolor # Color picker
      unstable.skanlite # Lightweight sane frontend
      unstable.xsane # Sane frontend (advanced)
      unstable.koreader # ebook reader
      unstable.xournalpp # notetaking software with PDF annotation support
      texlive.combined.scheme-medium
      biber
      unstable.keepassxc
      (unstable.python311.withPackages (_: [
        ]))
      # Nix
      unstable.alejandra # The uncompromising nix code formatter
      # Haskell
      unstable.stack
      unstable.ghc
      unstable.cabal-install
      unstable.cabal2nix
      # stack2nix # Broken
      # unstable.haskellPackages.summoner
      # unstable.haskellPackages.summoner-tui
      # unstable.haskellPackages.feedback # Declarative feedback loop manager
      unstable.hpack
      # Rust
      cargo
      crate2nix
      #
      unstable.pandoc
      unstable.redshift # Blue light filter
      unstable.imagemagick
      unstable.nitrogen # Wallpaper browser/setter for X11
      unstable.jmtpfs # MTP (Android phone) support
      unstable.mpv-unwrapped # Media player
      unstable.mdp # A command-line based markdown presentation tool
      unstable.kcat # A generic non-JVM producer and consumer for Apache Kafka
      paperkey # Print OpenPGP or GnuPG on paper
      unstable.asciinema # Terminal session recoreder
      unstable.playerctl
      unstable.gh # GitHub CLI tool
      unstable.act # Run GitHub workflows locally
      unstable.arduino-cli
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

  xdg = import ./xdg;
}
