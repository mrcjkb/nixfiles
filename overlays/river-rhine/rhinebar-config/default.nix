{ mkDerivation, base, colour, data-default, effectful, lib, pango
, rhinebar
}:
mkDerivation {
  pname = "rhinebar-config";
  version = "0.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base colour data-default effectful pango rhinebar
  ];
  description = "Rhinebar configuration";
  license = lib.meta.getLicenseFromSpdxId "MIT";
  mainProgram = "rhinebar-config";
}
