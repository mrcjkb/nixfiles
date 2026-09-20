{inputs, ...}: {
  perSystem = {
    system,
    pkgs,
    ...
  }: let
    pre-commit-check = inputs.git-hooks.lib.${system}.run {
      src = ../.;
      hooks = {
        alejandra.enable = true;
      };
    };
    shell = pkgs.mkShell {
      name = "nixfiles-devShell";
      inherit (pre-commit-check) shellHook;
      buildInputs = with pkgs; [
        alejandra
      ];
    };
  in {
    legacyPackages = pkgs;

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
