{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    devenv
    nix-output-monitor
    # pcmanfm # File browser like Nautilus, but with no Gnome dependencies
    yubioath-flutter # Yubico Authenticator Desktop app
    librsvg # Small SVG rendering library
    brave
    simplescreenrecorder
    inkscape
    # shutter # Screenshots
    signal-cli
    signal-desktop
    autorandr # Automatic XRandR configurations
    arandr # A simple visual front end for XRandR
    libnotify
    pdftk # Command-line tool for working with PDFs
    xclip
    xcolor # Color picker
    # xsane # Sane frontend (advanced)
    keepassxc
    redshift # Blue light filter
    imagemagick
    ghostscript
    # jmtpfs # MTP (Android phone) support - TODO: Find an alternative?
    mpv-unwrapped # Media player
    # kcat # A generic non-JVM producer and consumer for Apache Kafka
    paperkey # Print OpenPGP or GnuPG on paper
    t-rec # Terminal screen recorder
    playerctl
    gh # GitHub CLI tool
    element-desktop # Matrix client
    overskride # bluetooth client UI
    tmate # ssh terminal sharing
    perl # Needed by the zsh zplug plugin manager
    libreoffice
    zathura # Lightweight pdf/ebook viewer
    pcmanfm
    # needed to enable thumbnails
    ffmpeg-headless
    ffmpegthumbnailer
    gdk-pixbuf
    webp-pixbuf-loader
    chrysalis # keyboardio GUI configurator
  ];
}
