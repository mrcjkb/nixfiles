package: {
  inherit package;
  enable = true;

  envFile = ''
    mkdir -p ~/.cache/starship
    starship init nu | save ~/.cache/starship/init.nu
  '';

  configFile = ''
    let $config = {
      filesize_metric: false
      table_mode: rounded
      use_ls_colors: true
    }
    source ~/.cache/starship/init.nu
  '';
}
