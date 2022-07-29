{
  # NOTE: The interface names have to be determined per device.
  # They can be extracted from the generated configuration.nix
  networking = {
    hostName = "nixos-home-pc";
    interfaces = {
      enp3s0.useDHCP = true;
    };
  };
}
