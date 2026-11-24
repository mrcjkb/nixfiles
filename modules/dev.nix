{
  inputs,
  lib,
  findModulesList,
  ...
}: {
  perSystem = {
    system,
    pkgs,
    ...
  }: let
    pre-commit-check = inputs.git-hooks.lib.${system}.run {
      src = ../.;
      hooks = {
        alejandra = {
          enable = true;
          excludes = [
            "overlays/river-rhine/rhinebar-config/default.nix"
            "overlays/river-rhine/river-rhine-config/default.nix"
            "overlays/xmonad/xmobar-app/default.nix"
            "overlays/xmonad/xmonadrc/default.nix"
          ];
        };
        cabal2nix = {
          enable = true;
          files = "^overlays/(river-rhine|xmonad)/.*\\.cabal$";
        };
        editorconfig-checker = {
          enable = true;
          files = "^overlays/(river-rhine|xmonad)/";
        };
        markdownlint = {
          enable = true;
          files = "^overlays/xmonad/.*\\.md$";
        };
        fourmolu = {
          enable = true;
          files = "^overlays/(river-rhine|xmonad)/.*\\.hs$";
        };
        hlint = {
          enable = true;
          files = "^overlays/(river-rhine|xmonad)/.*\\.hs$";
        };
        stylua = {
          enable = true;
          files = "^overlays/neovim/.*\\.lua$";
        };
        luacheck = {
          enable = true;
          files = "^overlays/neovim/.*\\.lua$";
        };
      };
    };

    xmonadShell = pkgs.haskellPackages.shellFor {
      name = "xmonadrc-devShell";
      packages = p: [
        p.xmonadrc
        p.xmobar-app
      ];
      withHoogle = true;
      buildInputs =
        (with pkgs; [
          haskell-language-server
          cabal-install
          zlib
        ])
        ++ (with pkgs.haskellPackages; [
          implicit-hie
        ]);
    };

    shell = pkgs.mkShell {
      name = "nixfiles-devShell";
      inputsFrom = [xmonadShell];
      buildInputs = with pkgs; [
        alejandra
        lua-language-server
        vim-language-server
        nil
      ];
      shellHook =
        pre-commit-check.shellHook
        + ''
          (cd overlays/xmonad && gen-hie --cabal > hie.yaml)
          ln -fs ${pkgs.luarc-json} overlays/neovim/.luarc.json
        '';
    };
  in {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = lib.flatten (map (path: import path {inherit lib inputs;}) (findModulesList ../overlays));
    };

    legacyPackages = pkgs;

    packages = {
      river-rhine-config = pkgs.river-rhine-config;
      rhinebar-config = pkgs.rhinebar-config;
      xmonadrc = pkgs.haskellPackages.xmonadrc;
      xmobar-app = pkgs.haskellPackages.xmobar-app;
      nvim = pkgs.nvim-pkg;
      nvim-dev = pkgs.nvim-dev;
      nvim-profile = pkgs.nvim-profile;
      nightly = pkgs.neovim-nightly;
      luarc-json = pkgs.luarc-json;
    };

    devShells = {
      default = shell;
    };

    checks = {
      inherit pre-commit-check;
    };

    formatter = let
      config = pre-commit-check.config;
      inherit (config) package configFile;
      script = ''
        ${pkgs.lib.getExe package} run --all-files --config ${configFile}
      '';
    in
      pkgs.writeShellScriptBin "pre-commit-run" script;
  };
}
