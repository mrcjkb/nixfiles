{inputs, ...}: [
  inputs.jj.overlays.default
  (_: prev: let
    system = prev.stdenv.hostPlatform.system;
  in {
    jujutsu = prev.jujutsu.overrideAttrs (oa: {
      doCheck = false;
    });
    bash-env-nushell = inputs.bash-env-nushell.packages.${system}.default;
  })
]
