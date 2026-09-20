{lib}: let
  findModules = dir: let
    entries = builtins.readDir dir;
  in
    lib.concatMap (
      name: let
        path = dir + "/${name}";
      in
        if entries.${name} == "directory" && builtins.pathExists (path + "/default.nix")
        then [(path + "/default.nix")]
        else if entries.${name} == "directory"
        then findModules path
        else if lib.hasSuffix ".nix" name && name != "default.nix"
        then [path]
        else []
    ) (builtins.attrNames entries);
in
  findModules
