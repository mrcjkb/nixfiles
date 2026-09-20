{ mkDerivation, base, extra, lib, process, xmobar }:
mkDerivation {
  pname = "xmobar-app";
  version = "1.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  libraryHaskellDepends = [ base extra process xmobar ];
  executableHaskellDepends = [ base xmobar ];
  doHaddock = false;
  description = "My Modified xmobar app";
  license = "unknown";
  mainProgram = "xmobar-app";
}
