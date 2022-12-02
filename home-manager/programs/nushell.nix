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
        show_banner: false
        filesize_metric: false
        table_mode: rounded
        use_ls_colors: true
        hooks: {
          pre_prompt: [{
            code: "
              let direnv = (direnv export json | from json)
              let direnv = if ($direnv | length) == 1 { $direnv } else { {} }
              $direnv | load-env
            "
          }]
        }
      }
      source ~/.zoxide.nu
      source ~/.cache/starship/init.nu
    '';
  };
}
