{lib, ...}: {
  nix.monitored = {
    enable = lib.mkDefault true;
    notify = lib.mkForce false;
  };
}
