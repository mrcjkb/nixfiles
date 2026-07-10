{
  startAgent = false; # Start ssh-agent as a systemd user service
  knownHosts = {
    "github.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
    "aarch64-build-box.nix-community.org".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG9uyfhyli+BRtk64y+niqtb+sKquRGGZ87f4YRc8EE1";
    "build-box.nix-community.org".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIElIQ54qAy7Dh63rBudYKdbzJHrrbrrMXLYl7Pkmk88H";
    "darwin-build-box.nix-community.org".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKMHhlcn7fUpUuiOFeIhDqBzBNFsbNqq+NpzuGX3e6zv";
  };
  extraConfig = let
    comunnity-builders-identity-file = "/home/mrcjk/.ssh/community_builders";
    user = "mrcjkb";
  in ''
    Host darwin-builder
      Hostname darwin-build-box.nix-community.org
      IdentitiesOnly yes
      IdentityFile ${comunnity-builders-identity-file}
      User ${user}

    Host linux-aarch64-builder
      Hostname aarch64-build-box.nix-community.org
      IdentitiesOnly yes
      IdentityFile ${comunnity-builders-identity-file}
      User ${user}

    Host linux-x86-builder
      Hostname build-box.nix-community.org
      IdentitiesOnly yes
      IdentityFile ${comunnity-builders-identity-file}
      User ${user}
  '';
}
