{...}: {
  xdg.configFile = {
    bat = {
      source = ../configs/bat/.;
      recursive = true;
    };
  };

  home.file = {
    ".yubico" = {
      source = ../configs/.yubico/.;
      recursive = true;
    };
    ".direnvrc" = {
      text = ''
        source /run/current-system/sw/share/nix-direnv/direnvrc
      '';
    };
  };
}
