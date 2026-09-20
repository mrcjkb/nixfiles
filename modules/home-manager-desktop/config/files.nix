{pkgs, ...}: {
  xdg.configFile = {
    keepassxc = {
      source = ../configs/keepassxc/.;
      recursive = true;
    };
    Yubico = {
      source = ../configs/Yubico/.;
      recursive = true;
    };
  };

  home.file.".icons/default".source = "${pkgs.catppuccin-cursors.mochaDark}/share/icons/catppuccin-mocha-dark-cursors";
}
