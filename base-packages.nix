{ pkgs, unstable }:
{
  systemPackages = with pkgs; [
    (import (fetchGit "https://github.com/haslersn/fish-nix-shell"))
    # Create flakes-enabled alias for nix
    (pkgs.writeShellScriptBin "nixFlakes" ''
      exec ${pkgs.nixFlakes}/bin/nix --experimental-features "nix-command flakes" "$@"
    '')
    ### NeovVim dependencies
    unstable.neovim-remote
    unstable.vimPlugins.packer-nvim
    unstable.tree-sitter 
    unstable.sqlite # Required by neovim sqlite plugin - FIXME
    (unstable.lua.withPackages (luapkgs: with luapkgs; [
                                luacheck
                                plenary-nvim
                                luacov
    ]))
    unstable.rnix-lsp # Nix language server
    unstable.sumneko-lua-language-server
    unstable.nodePackages.vim-language-server
    unstable.nodePackages.yaml-language-server
    unstable.nodePackages.dockerfile-language-server-nodejs
    unstable.glow # Render markdown on the command-line
    unstable.bat # cat with syntax highlighting
    unstable.ueberzug # Display images in terminal
    unstable.feh # Fast and light image viewer
    unstable.fzf # Fuzzy search
    unstable.xclip # Required so that neovim compiles with clipboard support
    unstable.jdt-language-server
    ### End ov NeoVim dependencies

    cachix # Nix package caching
    unstable.neovim
    gcc
    gnumake
    alacritty
    xterm # xmonad default terminal
    unstable.xmobar
    unstable.rofi
    unstable.ranger # TUI file browser
    unstable.librsvg # Small SVG rendering library
    unstable.odt2txt
    unstable.pcmanfm # File browser like Nautilus, but with no Gnome dependencies
    unstable.keepassxc
    unstable.brave
    unstable.firefox
    unstable.joplin # Joblin (notes) CLI client
    unstable.joplin-desktop # Joblin (notes, desktop app)
    unstable.yubioath-desktop # Yubico Authenticator Desktop app
    unstable.yubikey-manager # Yubico Authenticator CLI
    unstable.shutter # Screenshots
    unstable.simplescreenrecorder
    unstable.inkscape-with-extensions
    unstable.gimp
    unstable.wireshark
    unstable.signal-desktop
    unstable.signal-cli
    unstable.cht-sh # CLI client for cheat.sh, a community driven cheat sheet
    unstable.pavucontrol # PulseAudio volume control
    unstable.libsForQt5.filelight
    unstable.gparted
    unstable.xcolor # Color picker
    unstable.skanlite # Lightweight sane frontend
    unstable.xsane # Sane frontend (advanced)
    unstable.calibre # ebook reader
    unstable.xournalpp # notetaking software with PDF annotation support
    (unstable.python310.withPackages (pythonPackages: with pythonPackages; [
    ]))
    unstable.python-language-server
    unstable.nodePackages.pyright
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
    unstable.haskellPackages.hoogle
    unstable.haskellPackages.hlint
    unstable.haskell-language-server
    unstable.haskellPackages.haskell-debug-adapter
    unstable.stylish-haskell
    # stack2nix # Broken
    # haskellPackages.summoner
    # haskellPackages.summoner-tui
    unstable.haskellPackages.implicit-hie ## Generate hie.yaml files with hie-gen
    # Rust
    unstable.crate2nix
    unstable.rust-analyzer
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
    unstable.ripgrep # Fast (Rust) re-implementation of grep
    unstable.fd # Fast alternative to find
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
    brightnessctl # Brightness control CLI
    upower # D-Bus service for power management
    unstable.dmenu # Expected by xmonad
    unstable.gxmessage # Used by xmonad to show help
    killall
    xorg.xkill # Kill X windows with the cursor
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
    unstable.pscircle # Generate process tree visualizations
    unstable.dconf # Required to set GTK theme in home-manager
    unstable.nodejs
    unstable.nodePackages.yarn # Required by markdown-preview vim plugin
    unstable.haskellPackages.greenclip # Clipboard manager for use with rofi
    unstable.scrot # A command-line screen capture utility
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
    #### NUR packages ###
    # (from mrcpkgs NUR package, managed by Marc Jakobi)
    # XXX Note: It may be necessary to update the nur tarball if a package is not found.
    nur.repos.mrcpkgs.nextcloud-no-de # nextcloud-client wrapper that waits for KeePass Secret Service Integration
  ];
}
