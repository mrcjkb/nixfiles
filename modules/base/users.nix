{
  pkgs,
  defaultUser,
  ...
}: {
  users = {
    defaultUserShell = pkgs.zsh;
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users."${defaultUser}" = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # Enable ‘sudo’ for the user.
        "networkmanager"
        "video"
        "scanner"
        "lp"
        "bluetooth"
        "adbusers"
        "abuild" # for alpine linux packaging
      ];
      shell = pkgs.zsh;
      # needed for rootless podman
      subUidRanges = [
        {
          startUid = 100000;
          count = 65536;
        }
      ];
      subGidRanges = [
        {
          startGid = 100000;
          count = 65536;
        }
      ];
    };
  };
}
