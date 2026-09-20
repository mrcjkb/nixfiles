{lib, ...}: {
  services = {
    pipewire.enable = lib.mkForce false; # Conflicts with pulseaudio
    pulseaudio = {
      enable = lib.mkDefault true;
      extraConfig = "
        # Automatically switch audio to the connected bluetooth device when it connects.
        load-module module-switch-on-connect
      ";
    };
    openssh = {
      enable = lib.mkDefault true;
      settings = {
        PasswordAuthentication = lib.mkDefault false;
        KbdInteractiveAuthentication = lib.mkDefault false;
      };
      extraConfig = ''
        AllowTcpForwarding yes
        X11Forwarding no
        AllowAgentForwarding no
        AllowStreamLocalForwarding no
        AuthenticationMethods publickey
      '';
    };
    upower.enable = lib.mkDefault true;
    # Yubikey
    pcscd.enable = lib.mkDefault true;
    # udev.packages = [pkgs.yubikey-personalization];
    automatic-timezoned.enable = lib.mkDefault true;
    geoclue2.enable = lib.mkDefault true;
    clamav = {
      daemon.enable = lib.mkDefault false;
      updater.enable = lib.mkDefault false;
    };
    fwupd.enable = true;
    libinput.touchpad.disableWhileTyping = lib.mkDefault true;
  };
}
