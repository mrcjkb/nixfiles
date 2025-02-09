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
          | str replace 'def-env' 'def --env' --all
          | save -f ~/.zoxide.nu

        mkdir ~/.cache/starship
        starship init nu
          | save -f ~/.cache/starship/init.nu
        mkdir ~/.local/share/atuin/
        atuin init nu
          | save -f ~/.local/share/atuin/init.nu
        mkdir ~/.cache/carapace
        $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
        carapace _carapace nushell
          | save --force ~/.cache/carapace/init.nu
      '';
  };

  configFile = {
    text =
      /*
      nu
      */
      ''
        use ${nu-scripts}/themes/nu-themes/material-darker.nu
        let zoxide_completer = {|spans|
          $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
        }
        let fish_completer = {|spans|
          fish --command $'complete "--do-complete=($spans | str join " ")"'
          | $"value(char tab)description(char newline)" + $in
          | from tsv --flexible --no-infer
        }
        let carapace_completer = {|spans: list<string>|
          carapace $spans.0 nushell ...$spans
          | from json
          | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
        }
        # This completer will use carapace by default
        let external_completer = {|spans|
          let expanded_alias = scope aliases
          | where name == $spans.0
          | get -i 0.expansion
          let spans = if $expanded_alias != null {
            $spans
            | skip 1
            | prepend ($expanded_alias | split row ' ' | take 1)
          } else {
            $spans
          }
          match $spans.0 {
            # carapace completions are incorrect for nu
            nu => $fish_completer
            # fish completes commits and branch names in a nicer way
            git => $fish_completer
            # carapace doesn't have completions for asdf
            asdf => $fish_completer
            # carapace doesn't have proper completions for nix
            nix => $fish_completer
            # use zoxide completions for zoxide commands
            __zoxide_z | __zoxide_zi => $zoxide_completer
            _ => $carapace_completer
          } | do $in $spans
        }
        $env.config = {
          color_config: (material-darker)
          show_banner: false
          edit_mode: vi
          history: {
            max_size: 100000
          }
          filesize: {
            unit: "metric"
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
              completer: $external_completer
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
          hooks: {
            pre_prompt: [{ ||
              if (which direnv | is-empty) {
                return
              }

              direnv export json | from json | default {} | load-env
            }]
          }
        }

        source ~/.zoxide.nu
        source ~/.cache/starship/init.nu
        source ~/.local/share/atuin/init.nu
        source ~/.cache/carapace/init.nu
        source ${nu-scripts}/sourced/filesystem/cdpath.nu
        source ${nu-scripts}/sourced/filesystem/up.nu
        # source ${nu-scripts}/sourced/api_wrappers/wolframalpha.nu
        source ${nu-scripts}/sourced/cool-oneliners/dict.nu
        # source ${nu-scripts}/custom-completions/bat/bat-completions.nu
        # source ${nu-scripts}/custom-completions/cargo/cargo-completions.nu
        # source ${nu-scripts}/custom-completions/curl/curl-completions.nu
        # source ${nu-scripts}/custom-completions/docker/docker-completions.nu
        # source ${nu-scripts}/custom-completions/gh/gh-completions.nu
        # source ${nu-scripts}/custom-completions/git/git-completions.nu
        # source ${nu-scripts}/custom-completions/gradlew/gradlew-completions.nu
        # source ${nu-scripts}/custom-completions/just/just-completions.nu
        # source ${nu-scripts}/custom-completions/less/less-completions.nu
        # source ${nu-scripts}/custom-completions/make/make-completions.nu
        # source ${nu-scripts}/custom-completions/man/man-completions.nu
        # source ${nu-scripts}/custom-completions/mysql/mysql-completions.nu
        # source ${nu-scripts}/custom-completions/nix/nix-completions.nu
        # source ${nu-scripts}/custom-completions/npm/npm-completions.nu
        # source ${nu-scripts}/custom-completions/pre-commit/pre-commit-completions.nu
        # source ${nu-scripts}/custom-completions/rg/rg-completions.nu
        # source ${nu-scripts}/custom-completions/ssh/ssh-completions.nu
        # source ${nu-scripts}/custom-completions/tar/tar-completions.nu
        # source ${nu-scripts}/custom-completions/typst/typst-completions.nu

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
        alias :te = nvim -c :te -c :startinsert
        alias :w = cowsay 'You are not in neovim anymore.'
        alias :wa = cowsay 'You are not in neovim anymore.'
        alias neogit = nvim -c :Neogit
        alias ngit = nvim -c :Neogit
        alias diffview = nvim -c :DiffviewOpen
        alias ndiff = nvim -c :DiffviewOpen
        alias nlog = nvim -c :DiffviewFileHistory

        alias "nix devel" = nix develop -c nu

        # git log to table
        def "git logt" [] { git log --pretty=%h»¦«%s»¦«%aN»¦«%aE»¦«%aD | lines | split column "»¦«" commit subject name email date | upsert date {|d| $d.date | into datetime} }
        def "git branch-cleanup" [] { git branch --merged | lines | where $it !~ '\*' | str trim | where $it != 'master' and $it != 'main' | each { |it| git branch -d $it } }

        # remove result from nix store
        def "nix-rm-result" [] { realpath result | lines | each {sudo nix-store --delete $in --ignore-liveness} }
      '';
  };
}
