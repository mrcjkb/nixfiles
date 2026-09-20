{
  lib,
  config,
  ...
}: {
  security = {
    # Use yubikey for login & sudo requests
    # pam = {
    # u2f.enable = lib.mkDefault true;
    # yubico = {
    #   enable = lib.mkDefault true;
    #   debug = lib.mkDefault true;
    #   mode = "challenge-response";
    # };
    # services = {
    #   login.u2fAuth = lib.mkDefault true;
    # };
    # };

    # audit rules to log every single time a program is attempted to be run.
    # auditd.enable = lib.mkDefault true;
    audit = {
      # Disabled by default, because it prints lots of logs to tty sessions
      enable = lib.mkDefault false;
      rules = [
        "-a exit,always -F arch=b64 -S execve"
      ];
    };
    sudo = {
      enable = !config.security.run0.enableSudoAlias;
      execWheelOnly = lib.mkDefault true;
    };
    run0 = {
      enable = lib.mkDefault true;
      enableSudoAlias = lib.mkDefault true;
    };
  };
}
