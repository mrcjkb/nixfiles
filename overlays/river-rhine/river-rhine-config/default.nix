{ mkDerivation, base, containers, data-default, lib, process
, river-rhine, text, unix
}:
mkDerivation {
  pname = "river-rhine-config";
  version = "0.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base containers data-default process river-rhine text unix
  ];
  description = "River-rhine configuration";
  license = lib.meta.getLicenseFromSpdxId "MIT";
  mainProgram = "river-rhine-config";
}
