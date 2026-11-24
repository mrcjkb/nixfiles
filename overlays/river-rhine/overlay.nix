{inputs, ...}: final: prev: let
  haskellPackages = inputs.river-rhine.legacyPackages.${final.stdenv.hostPlatform.system}.haskellPackages;
in {
  river-rhine-haskellPackages = haskellPackages;
  river-rhine-config = haskellPackages.callPackage ./river-rhine-config {};
  rhinebar-config = haskellPackages.callPackage ./rhinebar-config {};
}
