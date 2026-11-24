{ mkDerivation, base, data-default, lib, process, river-rhine, text
}:
mkDerivation {
  pname = "river-rhine-config";
  version = "0.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base data-default process river-rhine text
  ];
  description = "River-rhine configuration";
  license = lib.meta.getLicenseFromSpdxId "MIT";
  mainProgram = "river-rhine-config";
}
