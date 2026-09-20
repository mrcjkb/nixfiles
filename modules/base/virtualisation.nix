{lib, ...}: {
  virtualisation = {
    docker = {
      enable = lib.mkDefault false;
      autoPrune.enable = lib.mkDefault true;
      enableOnBoot = lib.mkDefault true;
    };
    podman.enable = lib.mkDefault true;
    containers.policy = {
      default = [{type = "insecureAcceptAnything";}];
    };
  };
}
