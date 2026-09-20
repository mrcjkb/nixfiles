{
  pkgs,
  lib,
  ...
}: {
  services = {
    # Enable CUPS to print documents.
    printing.enable = lib.mkDefault true;
    avahi = {
      # To find network scanners
      enable = lib.mkDefault true;
      nssmdns4 = lib.mkDefault true;
    };
    gvfs.enable = lib.mkDefault true; # MTP support for PCManFM
    logind.settings = {
      Login = {
        HandleLidSwitch = "hybrid-sleep";
        HandleLidSwitchExternalPower = "lock";
        HandleLidSwitchDocked = "lock";
        IdleAction = "hybrid-sleep";
        IdleActionSec = "30min";
        HandlePowerKey = "suspend";
        HandlePowerKeyLongPress = "poweroff";
      };
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
}
