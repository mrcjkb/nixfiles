{
  lib,
  git,
  jujutsu,
  writeShellApplication,
  makeBinaryWrapper,
}: let
  pname = "git-gud";
  inherit (git) version meta;
in
  writeShellApplication {
    name = "git";
    runtimeInputs = [git jujutsu];
    text = builtins.readFile ./git-gud.sh;
    inherit meta;
    derivationArgs = {
      inherit pname version;
      name = "${pname}-${version}";
      nativeBuildInputs = [makeBinaryWrapper];
      postCheck = ''
        makeBinaryWrapper '${lib.getExe git}' "$out/bin/git-real" --argv0 git
        ln -s '${git}/share' "$out/share"
      '';
    };
  }
