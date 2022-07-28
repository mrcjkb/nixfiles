{
  # NOTE: The interface names have to be determined per device.
  # They can be extracted from the generated configuration.nix
  networking.interfaces = {
    enp3s0.useDHCP = true;
  };
}
