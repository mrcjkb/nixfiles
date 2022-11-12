{ pkgs ? import <nixpkgs> {} }:
let
  python = pkgs.python39.withPackages (p: with p; [
  ]);
in
pkgs.mkShell {
  buildInputs = [
    python
    pkgs.ranger
  ];
  shellHook = ''
    PYTHONPATH="${python}/${python.sitePackages}:${pkgs.ranger}/lib/python3.9/site-packages"
    # maybe set more env-vars
  '';
}
