{pkgs, ...}: {
  programs.gnupg = {
    package = pkgs.gnupg;
    agent = {
      enable = true;
      enableSSHSupport = true;
      settings = {
        default-cache-ttl = 3600;
        max-cache-ttl = 14400;
      };
    };
  };
}
