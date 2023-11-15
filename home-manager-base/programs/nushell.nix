{
  package,
  nu-scripts,
}: {
  inherit package;
  enable = true;

  envFile = {
    text =
      /*
      nu
      */
      ''
        zoxide init nushell
          | str replace 'let-env ' "\$\$env." --all
          | save -f ~/.zoxide.nu

        mkdir ~/.cache/starship
        starship init nu
          | save -f ~/.cache/starship/init.nu
        mkdir ~/.local/share/atuin/
        atuin init nu
          | save -f ~/.local/share/atuin/init.nu
      '';
  };

  configFile = {
    text =
      /*
      nu
      */
      ''
        use ${nu-scripts}/themes/nu-themes/material-darker.nu
        let carapace_completer = {|spans|
          carapace $spans.0 nushell $spans | from json
        }
        $env.config = {
          color_config: (material-darker)
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
          completions: {
            external: {
              enable: true
              max_results: 100
              completer: $carapace_completer
            }
            algorithm: "fuzzy"
          }
          keybindings: [
            {
              name: menu_accept
              modifier: control
              keycode: char_y
              mode: [emacs, vi_normal, vi_insert]
              event: { send: Enter }
            }
            {
              name: completion_menu_open
              modifier: control
              keycode: char_n
              mode: [emacs, vi_normal, vi_insert]
              event: {
                until: [
                        { send: menu name: completion_menu }
                        { send: menunext }
                        { edit: complete }
                       ]
              }
            }
          ]
        }

        source ~/.zoxide.nu
        source ~/.cache/starship/init.nu
        source ~/.local/share/atuin/init.nu
        source ${nu-scripts}/sourced/filesystem/cdpath.nu
        source ${nu-scripts}/sourced/filesystem/up.nu
        # source ${nu-scripts}/sourced/api_wrappers/wolframalpha.nu
        source ${nu-scripts}/sourced/cool-oneliners/dict.nu

        alias cd = z
        alias eza = eza --icons --git
        alias la = eza --icons --git -a
        alias ll = eza --icons --git -l
        alias lt = eza --icons --tree
        alias br = broot
        alias grep = rg
        alias cat = bat --style=plain
        alias cloc = tokei
        alias top = btm
        alias htop = btm
        alias vi = nvim
        alias vis = nvim -c S
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

        # git log to table
        def "git logt" [] { git log --pretty=%h»¦«%s»¦«%aN»¦«%aE»¦«%aD | lines | split column "»¦«" commit subject name email date | upsert date {|d| $d.date | into datetime} }
        def "git branch-cleanup" [] { git branch --merged | lines | where $it !~ '\*' | str trim | where $it != 'master' and $it != 'main' | each { |it| git branch -d $it } }
      '';
  };
}
