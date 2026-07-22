pkgs: let
  inherit (pkgs) lib haskellPackages fetchFromGitHub;

  hoogle-mcp-src = fetchFromGitHub {
    owner = "jaredramirez";
    repo = "hoogle-mcp";
    rev = "2fb63b11f4cf9c4fc9d3c3af347712c3146877a9";
    hash = "sha256-Hg3atjs1mgs89jBSuZlBi76Hnq9hfoixejvcTZA7OvM=";
    postFetch = ''
      substituteInPlace "$out/hoogle-mcp.cabal" \
        --replace-fail 'cabal-version: 3.14' 'cabal-version: 3.0'
    '';
  };
  hoogle-mcp =
    (
      haskellPackages.callCabal2nix "hoogle-mcp" hoogle-mcp-src {}
    ).overrideAttrs (attrs:
      lib.recursiveUpdate attrs {
        meta.mainProgram = "hoogle-mcp";
      });
in {
  enable = true;
  servers = {
    hoogle = {
      enabled = true;
      command = pkgs.lib.getExe hoogle-mcp;
    };
    serena = {
      enabled = true;
      command = "serena";
      args = [
        "start-mcp-server"
        "--context"
        "ide"
        "--project"
        "."
      ];
    };
  };
}
