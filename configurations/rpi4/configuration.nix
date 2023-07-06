{
  defaultUser,
  pkgs,
  ...
}: {
  # Workaround, see https://github.com/NixOS/nixpkgs/issues/126755#issuecomment-869149243
  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // {allowMissing = true;});
    })
  ];

  boot = {
    loader.grub.enable = false;
  };

  users.users."${defaultUser}" = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBnigcZQYelN4XUnEAEfw1NoNLcWN8EOUJEbogiq/WCK mrcjkb89@outlook.com"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCeNmtIzKDnSsHlASczRN8wBBrdmt8MlN/vOEu/n0z2CuOa13WhubiLVLkygoRblPivwKaNGxqZzODZAfnOHGDrSZ2Dc6Qw5rW4ZqcIn3V3Z+p6vIgov+QdT+s/VBTWv8tm9AB3Pl2KO8kJvvD/rpBe219hMjCJTLUXzuFeYYJwP136JJ+biZidkaRpU7GXp6/tfmO9/TZlj+6KaVfJ/oSweTehoKxvujhyehxRNzimT494Xg6X1Ww8L+k5J6PucT72sZJLCTmXppg8bMM8Ejc5T5M0Bx4t8ar8n1bGQm59zb24TU/gJf0Yx3VFljr/wYmT9cuqrESghCgBmUdHJ/VepADvzv8wRiPUomNszXetUba1ybUmWTvFcTmprXY+Zcdb0/UvLzpaFCfDbs2FWY+3QsnSI78V6QKZfzCD2XcaXdWBhHvYO0sGJ3JJ9atnJ1vNft3nVKCx/cRzvCrC0Zw8ddpqQuzLaTGcNInvV6V17xzArv1jokAnn779juGOW1AP7F64NHLUh8rJ+ryny/s+HwHOWLWDwT/JlnoYJ5ph0WmeKoKuvFG4qkZmmYWDfYRMHLtw6o4QfJKRAmyW//K7ob9TM5FXI7Qm1ejoSgwCxWfv1QWhIN4j+ykqNmyLdjLzhnQpQtitbGQ/K3yeDcPl4oGGNOE02RaEDYRQN9anjw== mrcjkb89@outlook.com"
    ];
  };

  networking = {
    hostName = "nixos-rpi4";
    networkmanager.enable = false;
  };

  home-manager = {
    users."${defaultUser}" = {
      home.stateVersion = "22.11";
    };
  };

  system = {
    build.hostPlatform.config = {
      buildInputs = [pkgs.gcc-arm-embedded];
    };
    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    stateVersion = "22.11"; # Did you read the comment?
  };
}
