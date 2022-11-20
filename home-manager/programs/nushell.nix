package: {
  inherit package;
  enable = true;

  envFile = {
    text = ''
      mkdir -p ~/.cache/starship
      starship init nu | save ~/.cache/starship/init.nu
    '';
  };

  configFile = {
    text = ''
      source ~/.cache/starship/init.nu
    '';
  };
}
