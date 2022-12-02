package: {
  inherit package;
  enable = true;

  envFile = {
    text = ''
      mkdir ~/.cache/starship
      zoxide init nushell | save ~/.zoxide.nu
      starship init nu | str replace 'term size -c' 'term size' | save ~/.cache/starship/init.nu
    '';
  };

  configFile = {
    text = ''
      let-env config = {
        show_bqnner: false
        filesize_metric: false
        table_mode: rounded
        use_ls_colors: true
      }
      source ~/.zoxide.nu
      source ~/.cache/starship/init.nu
    '';
  };
}
