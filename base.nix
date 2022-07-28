{ pkgs, defaultUser }:
let 
  nur-revision = "da216d5e95ce674d36f6ad6bb759c5afb77eb757";
  nur = builtins.fetchTarball {
    # Choose the revision from https://github.com/nix-community/NUR/commits/master
    url = "https://github.com/nix-community/NUR/archive/${nur-revision}.tar.gz";
    # Get the hash by running `nix-prefetch-url --unpack <url>` on the above url
    sha256 = "1ca8zsn1l88cls3k97xn4fddwsn8yfqkkywl7xp588giwvk3xcv9";
  };
in {

  nixpkgs.config = {
    # Allow unfree/proprietary packages
    # allowUnfree = true;
    # allowBroken = true;
    packageOverrides = pkgs: {
      # Nix User Repository
      nur = import nur { inherit pkgs; };
      xsaneGimp = pkgs.xsane.override { gimpSupport = true; }; # Support for scanning in GIMP
      # NOTE: For GIMP scanning, a symlink must be created manually: ln -s /run/current-system/sw/bin/xsane ~/.config/GIMP/2.10/plug-ins/xsane
    };
  };

  # Boot loader
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        # Disallow editing the kernel command-line befor boot
        # Enabling this allows gaining root access by passing init=/bin/sh as a kernel parameter
        editor = false; 
        # Maximum number of latest generations in the boot menu.
        configurationLimit = 50;
      };
    };
    cleanTmpDir = true;
    tmpOnTmpfs = true;
  };

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true; # Enables wireless support via NetworkManager
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  time.timeZone = "Europe/Amsterdam";

  # Internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  console = { font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services = {
    # Enable blueman if the DE does not provide a bluetooth management GUI.
    blueman.enable = true;
    # Enable CUPS to print documents.
    printing.enable = true;
    avahi = { # To find network scanners
      enable = true;
      nssmdns = true;
    };
    openssh.enable = true;
    onedrive.enable = true;
    upower.enable = true;
    gvfs.enable = true; # MTP support for PCManFM
    # Yubikey
    pcscd.enable = true;
    udev.packages = [ pkgs.yubikey-personalization ];
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
}
