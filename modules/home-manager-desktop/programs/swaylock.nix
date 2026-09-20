{lib, ...}: {
  # a buggy nixpkgs module causing infinite recursion in evaluation
  programs.swaylock.enable = lib.mkForce false;
}
