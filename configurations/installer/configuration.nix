# ISO installation medium configuration
{
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-graphical-base.nix")
  ];

  system.nixos.variant_id = "installer";
  isoImage.edition = "xmonad";

  services = {
    xserver = {
      # Configure keymap in X11
      xkb = {
        layout = "us,de";
        variant = "altgr-intl,";
        options = "grp:alt_shift_toggle";
      };
      # Enable touchpad support (enabled default in most desktopManager).
      libinput.enable = true;
    };
    displayManager = {
      autoLogin = {
        enable = true;
        user = "nixos";
      };
    };
  };
  home-manager.users.nixos.home.stateVersion = "23.11";

  environment.systemPackages = with pkgs; [
    # Calamares for graphical installation
    libsForQt5.kpmcore
    calamares-nixos
    calamares-nixos-extensions
    # Get list of locales
    glibcLocales
  ];

  # Support choosing from any locale
  i18n.supportedLocales = ["all"];
}
