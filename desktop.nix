# Base module to be added to desktop systems
{ pkgs, userEmail ? "mrcjkb89@outlook.com", ... }:
{

  services = {
    # Enable CUPS to print documents.
    printing.enable = true;
    avahi = { # To find network scanners
      enable = true;
      nssmdns = true;
    };
    onedrive = {
      enable = true;
      package = pkgs.unstable.onedrive;
    };
    gvfs.enable = true; # MTP support for PCManFM
    logind.lidSwitch = "ignore";
  };

  hardware = {
    sane = {
      enable = true; # Scanner support
      extraBackends = [
        pkgs.sane-airscan # Driverless scanning support
        # pkgs.hplipWithPlugin # HP support - requires allowUnfree = true
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    unstable.pcmanfm # File browser like Nautilus, but with no Gnome dependencies
    yubioath-desktop # Yubico Authenticator Desktop app
    brave
    unstable.firefox-bin
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
    unstable.arduino-cli
  ];

  xdg = import ./xdg;

}