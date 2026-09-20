{lib, ...}: {
  hardware = {
    bluetooth = {
      enable = lib.mkDefault true;
      settings = {
        General = {
          # Modern headsets will generally try to connect using the A2DP profile.
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
  };
}
