pkgs: {
  enable = pkgs.lib.mkDefault true;
  wrappedBinaries = {
    firefox = {
      executable = "${pkgs.lib.getBin pkgs.firefox}/bin/firefox";
      profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
    };
    # brave = {
    #   executable = "${pkgs.lib.getBin pkgs.brave}/bin/brave";
    #   profile = "${pkgs.firejail}/etc/firejail/brave.profile";
    # };
  };
}
