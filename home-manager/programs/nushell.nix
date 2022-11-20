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
      let $config = {
        filesize_metric: false
        table_mode: rounded
        use_ls_colors: true
      }
      source ~/.cache/starship/init.nu
    '';
  };
}
