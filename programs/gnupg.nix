package: {
  inherit package;
  agent = {
    enable = true;
    enableSSHSupport = true;
    settings = {
      default-cache-ttl = 3600;
      max-cache-ttl = 14400;
    };
  };
}
