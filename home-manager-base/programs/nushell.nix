package: {
  inherit package;
  enable = true;

  envFile = {
    text = ''
      zoxide init nushell
        | str replace 'let-env ' "\$\$env." --all
        | save -f ~/.zoxide.nu

      mkdir ~/.cache/starship
      starship init nu
        | save -f ~/.cache/starship/init.nu
    '';
  };

  configFile = {
    text = ''
      let carapace_completer = {|spans|
        carapace $spans.0 nushell $spans | from json
      }
      $env.config = {
        show_banner: false
        edit_mode: vi
        history: {
          max_size: 100000
        }
        filesize: {
          metric: true
        }
        ls: {
          use_ls_colors: true
        }
        table: {
          mode: rounded
        }
        hooks: {
          pre_prompt: [{
            code: "
              let direnv = (direnv export json | from json)
              let direnv = if ($direnv | length) == 1 { $direnv } else { {} }
              $direnv | load-env
            "
          }]
        }
        completions: {
          external: {
            enable: true
            max_results: 100
            completer: $carapace_completer
          }
          algorithm: "fuzzy"
        }
      }
      source ~/.zoxide.nu
      source ~/.cache/starship/init.nu
      alias cd = z
      alias eza = eza --icons --git
      alias la = eza --icons --git -a
      alias ll = eza --icons --git -l
      alias lt = eza --icons --tree
      alias grep = rg
      alias cat = bat --style=plain
      alias cloc = tokei
      alias top = btm
      alias htop = btm
      alias vi = nvim
      alias vim = nvim
      alias nv = neovide
      alias :e = nvim
      alias :q = exit
      alias :qa = exit
      alias :wq = exit
      alias :x = exit
      alias :w = cowsay 'You are not in neovim anymore.'
      alias :wa = cowsay 'You are not in neovim anymore.'
      alias neogit = nvim -c :Neogit
      alias ngit = nvim -c :Neogit
      alias diffview = nvim -c :DiffviewOpen
      alias ndiff = nvim -c :DiffviewOpen
      alias nlog = nvim -c :DiffviewFileHistory
    '';
  };
}
