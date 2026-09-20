{inputs, ...}: {
  perSystem = {
    system,
    pkgs,
    ...
  }: let
    xmonadOverlay = import ../xmonad/nix/overlay.nix {};

    pre-commit-check = inputs.git-hooks.lib.${system}.run {
      src = ../.;
      hooks = {
        alejandra = {
          enable = true;
          excludes = [
            "xmonad/xmobar-app/default.nix"
            "xmonad/xmonadrc/default.nix"
          ];
        };
        cabal2nix = {
          enable = true;
          files = "^xmonad/.*\\.cabal$";
        };
        editorconfig-checker = {
          enable = true;
          files = "^xmonad/";
        };
        markdownlint = {
          enable = true;
          files = "^xmonad/.*\\.md$";
        };
        fourmolu = {
          enable = true;
          files = "^xmonad/.*\\.hs$";
        };
        hlint = {
          enable = true;
          files = "^xmonad/.*\\.hs$";
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
      ];
      shellHook =
        pre-commit-check.shellHook
        + ''
          (cd xmonad && gen-hie --cabal > hie.yaml)
        '';
    };
  in {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [xmonadOverlay];
    };

    legacyPackages = pkgs;

    packages = {
      xmonadrc = pkgs.haskellPackages.xmonadrc;
      xmobar-app = pkgs.haskellPackages.xmobar-app;
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
