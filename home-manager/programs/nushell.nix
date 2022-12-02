package: {
  inherit package;
  enable = true;

  envFile = {
    text = ''
      mkdir ~/.cache/starship
      zoxide init nushell | save ~/.zoxide.nu
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
      source ~/.zoxide.nu
      source ~/.cache/starship/init.nu
    '';
  };
}
