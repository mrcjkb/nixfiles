{pkgs, ...}: {
  environment.systemPackages = with pkgs; let
    manix-fzf = pkgs.writeShellApplication {
      name = "nixf";
      runtimeInputs = [manix ripgrep fzf];
      text = "manix \"\" | rg '^# ' | sed 's/^# \\(.*\\) (.*/\\1/;s/ (.*//;s/^# //' | fzf --preview=\"manix '{}'\" | xargs manix";
    };
  in [
    haskellPackages.hoogle
    nil
    git-credential-keepassxc
    difftastic
    delta # A syntax-highlighting pager for git, diff, and grep output
    cachix # Nix package caching
    manix
    manix-fzf
    nix-diff # Explain why 2 nix derivations differ
    skim
    ripgrep
    ripgrep-all # Also search in PDFs, e-books, zip, tar.gz, and more (with rga-fzf integration)
    fd
    lsof # list open files
    # tailspin # Log file highlighter
    odt2txt
    # joplin # Joplin (notes) CLI client
    yubikey-manager # Yubico Authenticator CLI
    wget
    curl
    xh # Alternative to curl
    whois
    file
    moreutils
    fastfetch # System information CLI
    zip
    unzip
    eza # Replacement for ls
    killall
    zoxide # Fast alternative to autojump and z-lua
    carapace # Multi-shell multi-command argument completer
    fish # Needed for nushell's fish_completer
    pandoc
    tectonic # --pdf-backend for pandoc
    jq
    binutils
    dig # Domain information groper
    nmap
    update-systemd-resolved
    dconf # Required to set GTK theme in home-manager
    tokei # Count lines of code
    bottom # Alternative to htop
    dust # CLI alternative to du
    ncdu # TUI alternative to du
    procs # Alternative to ps
    sd # Alternative to sed
    sad # Space Age seD
    bat
    ueberzugpp
    feh
    hyperfine # Alternative to time
    tealdeer # tldr implementation for simplified example based man pages
    openssl
    usbutils
    nix-index # A files database for nix
    nixos-option
    direnv
    nix-direnv
    tmux-sessionizer # The fastest way to manage projects as tmux sessions
    zlib # Lossles data compression library
    pciutils # Inspection/manipulation of PCI devices
    bluetuith # Bluetooth TUI
    neo-cowsay
    dive # A tool for exploring each layer in a docker image
    page # pager that uses Neovim
    watchman # filesystem monitor used by jj
    # terminal sharing: `dumbpipe connect-tcp ... & tty-share ...`
    tty-share
    dumbpipe
    rsync # fast copying, good for lots of small files
  ];
}
