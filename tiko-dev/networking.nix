{
  # NOTE: The interface names have to be determined per device.
  # They can be extracted from the generated configuration.nix
  networking.interfaces = {
    enp4s0.useDHCP = true;
    wlp0s20f3.useDHCP = true;
  };
}
